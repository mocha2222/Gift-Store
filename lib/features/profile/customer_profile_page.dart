import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import '../../router/app_router.dart';
import '../../services/user_api.dart';
import '../../services/product_api.dart';
import '../../services/cart_service.dart';
import '../favorites/widgets/favorite_notifier.dart';
import '../auth/login_page.dart';
import 'edit_profile_page.dart';
import 'following_page.dart';
import 'my_address_page.dart';
import 'notifications_page.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_menu_section.dart';
import 'widgets/profile_stats_row.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key, this.showAppBar = false});

  final bool showAppBar;

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  String _name = '';
  String _email = '';
  String _initials = '';
  String _joined = '';
  int _followingCount = 0;
  int _orderCount = 0;
  File? _localImage;
  Uint8List? _imageBytes;

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFFB8402A)
            : const Color(0xFF4A321B),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    Uint8List? imageBytes;
    File? localFile;

    // Try loading avatar from local cache first
    if (kIsWeb) {
      final base64Str = prefs.getString('user_avatar_bytes');
      if (base64Str != null && base64Str.isNotEmpty) {
        imageBytes = base64Decode(base64Str);
      }
    } else {
      // First check local base64 cache (synced from backend)
      final base64Str = prefs.getString('user_avatar_bytes');
      if (base64Str != null && base64Str.isNotEmpty) {
        imageBytes = base64Decode(base64Str);
      } else {
        final avatarPath = prefs.getString('user_avatar_path');
        if (avatarPath != null && avatarPath.isNotEmpty) {
          final file = File(avatarPath);
          if (await file.exists()) localFile = file;
        }
      }
    }

    // If no local avatar, try fetching from backend
    if (imageBytes == null && localFile == null) {
      try {
        final userData = await UserApi.getMe();
        final profileImage = userData['profile_image'];
        if (profileImage != null && profileImage.toString().isNotEmpty) {
          await prefs.setString('user_avatar_bytes', profileImage as String);
          imageBytes = base64Decode(profileImage);
        }
      } catch (_) {
        // Silently fail — user may be offline
      }
    }

    int orderCount = 0;
    try {
      final userId = prefs.getString('user_id');
      if (userId != null && userId.isNotEmpty) {
        final orders = await ProductApi.getCustomerOrders(userId);
        orderCount = orders.length;
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _name = prefs.getString('user_name') ?? 'Guest';
      _email = prefs.getString('user_email') ?? '';
      _initials = prefs.getString('user_initials') ?? 
          (_name.isNotEmpty ? _name[0].toUpperCase() : 'G');
      _joined = prefs.getString('user_joined') ?? '';
      _followingCount =
          (prefs.getStringList('followed_artisans') ?? const []).length;
      _orderCount = orderCount;
      _localImage = localFile;
      _imageBytes = imageBytes;
    });
  }

  String get _joinedFormatted {
    if (_joined.isEmpty) {
      return '';
    }

    try {
      final date = DateTime.parse(_joined);
      return 'Member since ${date.year}';
    } catch (_) {
      return '';
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
      );

      if (picked == null) {
        _showMessage('Image selection canceled.');
        return;
      }

      final bytes = await picked.readAsBytes();
      final base64Str = base64Encode(bytes);

      // Save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_avatar_bytes', base64Str);

      if (!kIsWeb) {
        final savedImage = await _persistFile(File(picked.path));
        await prefs.setString('user_avatar_path', savedImage.path);
        if (!mounted) return;
        setState(() {
          _localImage = savedImage;
          _imageBytes = bytes;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _imageBytes = bytes;
        });
      }

      // Sync to backend database
      try {
        await UserApi.updateProfileImage(base64Str);
        _showMessage('Profile picture updated and saved.');
      } catch (e) {
        _showMessage('Picture saved locally but failed to sync: $e', isError: true);
      }
    } catch (e) {
      _showMessage('Error: $e', isError: true);
    }
  }

  Future<File> _persistFile(File file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final profileDir = Directory('${appDir.path}/profile');
    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }

    final extension = file.path.contains('.')
        ? file.path.substring(file.path.lastIndexOf('.'))
        : '.jpg';
    final fileName =
        'avatar_${DateTime.now().millisecondsSinceEpoch}$extension';
    final savedPath = '${profileDir.path}/$fileName';

    return file.copy(savedPath);
  }

  Future<void> _openEditProfilePage() async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          initialName: _name,
          initialEmail: _email,
          initialImage: _localImage,
        ),
      ),
    );

    if (updated == true) {
      await _loadUserData();
      _showMessage('Profile updated successfully.');
    }
  }

  Future<void> _openFollowingPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const FollowingPage()));
    await _loadUserData();
  }

  Future<void> _openOrdersPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const _OrdersHistoryPage(),
      ),
    );
    _loadUserData();
  }

  Future<void> _openFavoritesPage() async {
    await Navigator.of(context).pushNamed(AppRoutes.favorites);
  }

  Future<void> _openMyAddressPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MyAddressPage()));
  }

  Future<void> _openNotificationsPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NotificationsPage()));
  }

  Future<void> _openAboutUsPage() async {
    Navigator.of(context).pushNamed('/about-us');
  }

  Future<void> _confirmDeleteAccount() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFF7EC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete account?',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF231408),
            ),
          ),
          content: Text(
            'This will remove your profile, saved photo, and local account data from this device.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF5E5244),
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8C6500),
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFC0392B),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarPath = prefs.getString('user_avatar_path');

    if (avatarPath != null && avatarPath.isNotEmpty) {
      final avatarFile = File(avatarPath);
      if (await avatarFile.exists()) {
        await avatarFile.delete();
      }
    }

    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_initials');
    await prefs.remove('user_joined');
    await prefs.remove('user_avatar_bytes');
    await prefs.remove('user_avatar_path');
    await prefs.remove('user_password');
    await prefs.remove('followed_artisans');
    await prefs.remove('favorite_products');
    await prefs.remove('cart_items');

    if (!mounted) return;
    Provider.of<CartService>(context, listen: false).reset();
    Provider.of<FavoriteNotifier>(context, listen: false).reset();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_initials');
    await prefs.remove('user_joined');
    await prefs.remove('user_avatar_bytes');
    await prefs.remove('user_avatar_path');
    await prefs.remove('user_password');
    await prefs.remove('followed_artisans');

    if (!mounted) return;
    Provider.of<CartService>(context, listen: false).reset();
    Provider.of<FavoriteNotifier>(context, listen: false).reset();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E4),
      appBar: widget.showAppBar
          ? AppBar(
              leadingWidth: 64,
              leading: Padding(
                padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAD5A8)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF231408),
                      size: 20,
                    ),
                  ),
                ),
              ),
              title: Text(
                'Profile',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8C6500),
                ),
              ),
              backgroundColor: const Color(0xFFF7F0E4),
              elevation: 0,
              scrolledUnderElevation: 0,
              foregroundColor: const Color(0xFF231408),
            )
          : null,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileAvatar(
                    initials: _initials,
                    localFile: kIsWeb ? null : _localImage,
                    imageBytes: kIsWeb ? _imageBytes : null,
                    radius: 52,
                    showEditButton: true,
                    onEditTap: _pickImage,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _name.isEmpty ? 'Guest' : _name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF231408),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _email,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF9E7E5A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _joinedFormatted,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF9E7E5A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: ProfileStatsRow(
                stats: [
                  (label: 'Orders', value: '$_orderCount'),
                  (label: 'Favorite', value: Provider.of<FavoriteNotifier>(context).items.length.toString()),
                  (label: 'Following', value: '$_followingCount'),
                ],
                onStatTap: [
                  _openOrdersPage,
                  _openFavoritesPage,
                  _openFollowingPage,
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: ProfileMenuSection(
                title: 'Account',
                items: [
                  ProfileMenuItem(
                    icon: Icons.receipt_long_rounded,
                    label: 'My Orders',
                    onTap: _openOrdersPage,
                  ),
                  ProfileMenuItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'Favorite',
                    onTap: _openFavoritesPage,
                  ),
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    label: 'My Address',
                    onTap: _openMyAddressPage,
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 18)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: ProfileMenuSection(
                title: 'Settings',
                items: [
                  ProfileMenuItem(
                    icon: Icons.edit_outlined,
                    label: 'Edit Profile',
                    onTap: _openEditProfilePage,
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: _openNotificationsPage,
                  ),
                  ProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About Us',
                    onTap: _openAboutUsPage,
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    isDestructive: true,
                    onTap: _signOut,
                  ),
                  ProfileMenuItem(
                    icon: Icons.delete_forever_rounded,
                    label: 'Delete Account',
                    isDestructive: true,
                    onTap: _confirmDeleteAccount,
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
        ],
      ),
    );
  }
}

class _EmptyStatePage extends StatelessWidget {
  const _EmptyStatePage({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E4),
      appBar: AppBar(
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAD5A8)),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF231408),
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8C6500),
          ),
        ),
        backgroundColor: const Color(0xFFF7F0E4),
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF231408),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 42),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF231408),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF9E7E5A),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrdersHistoryPage extends StatefulWidget {
  const _OrdersHistoryPage();

  @override
  State<_OrdersHistoryPage> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<_OrdersHistoryPage> {
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId == null || userId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final orders = await ProductApi.getCustomerOrders(userId);
      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F0E4),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF8C6500))),
      );
    }

    if (_orders.isEmpty) {
      return const _EmptyStatePage(
        title: 'My Orders',
        message: 'You have not placed any orders yet.',
        icon: Icons.receipt_long_rounded,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E4),
      appBar: AppBar(
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAD5A8)),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF231408),
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          'My Orders',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF8C6500),
          ),
        ),
        backgroundColor: const Color(0xFFF7F0E4),
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF231408),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index] as Map<String, dynamic>;
          final orderId = order['_id']?.toString() ?? order['id']?.toString() ?? 'ORD-0000000';
          
          String date = '';
          if (order['createdAt'] != null || order['created_at'] != null) {
            try {
              final dt = DateTime.parse((order['createdAt'] ?? order['created_at']).toString());
              final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
              date = '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
            } catch (_) {}
          }

          final num totalNum = order['total_price'] as num? ?? 0;
          final total = '\$${totalNum.toStringAsFixed(2)}';
          final address = order['shipping_address']?.toString() ?? '';
          
          String name = '';
          final user = order['user_id'];
          if (user is Map) {
            name = user['name']?.toString() ?? '';
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEDE1CB)),
            ),
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF4F453A),
                      ),
                    ),
                    Text(
                      total,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFF8C6500),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9E7E5A),
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8C6500),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: Color(0xFF8C6500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  final itemsList = order['items'] as List<dynamic>? ?? [];
                  final productsList = itemsList.map((item) {
                    final qty = item['quantity'] ?? 1;
                    final prod = item['product_id'];
                    final prodName = prod is Map ? (prod['name'] ?? 'Gift') : 'Gift';
                    return '$qty x $prodName';
                  }).toList();

                  Navigator.of(context).pushNamed(
                    AppRoutes.checkoutDetails,
                    arguments: CheckoutDetailsArgs(
                      orderId: orderId,
                      customerName: name,
                      deliveryAddress: address,
                      totalPaid: total,
                      date: date,
                      products: productsList,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
