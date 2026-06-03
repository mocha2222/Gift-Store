import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/user_api.dart';
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

    if (!mounted) return;
    setState(() {
      _name = prefs.getString('user_name') ?? 'Guest';
      _email = prefs.getString('user_email') ?? '';
      _initials = prefs.getString('user_initials') ?? 
          (_name.isNotEmpty ? _name[0].toUpperCase() : 'G');
      _joined = prefs.getString('user_joined') ?? '';
      _followingCount =
          (prefs.getStringList('followed_artisans') ?? const []).length;
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
        builder: (_) => const _EmptyStatePage(
          title: 'My Orders',
          message:
              'Your order history will appear here once checkout is added.',
          icon: Icons.receipt_long_rounded,
        ),
      ),
    );
  }

  Future<void> _openFavoritesPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const _EmptyStatePage(
          title: 'Favorites',
          message:
              'Saved items will appear here once the favorites flow is added.',
          icon: Icons.favorite_border_rounded,
        ),
      ),
    );
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
    await prefs.remove('user_avatar_path');
    await prefs.remove('user_password');
    await prefs.remove('followed_artisans');
    await prefs.remove('favorite_products');
    await prefs.remove('cart_items');

    if (!mounted) return;
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
    await prefs.remove('user_avatar_path');
    await prefs.remove('user_password');
    await prefs.remove('followed_artisans');

    if (!mounted) return;
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
                  (label: 'Orders', value: '0'),
                  (label: 'Favorite', value: '0'),
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
