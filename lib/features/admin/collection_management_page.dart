import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/admin_api.dart';
import 'admin_models.dart';

class CollectionManagementPage extends StatefulWidget {
  const CollectionManagementPage({super.key});

  @override
  State<CollectionManagementPage> createState() => _CollectionManagementPageState();
}

class _CollectionManagementPageState extends State<CollectionManagementPage> {
  List<dynamic> _collections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    setState(() => _isLoading = true);
    try {
      final cols = await AdminApi.fetchCollections();
      if (mounted) {
        setState(() {
          _collections = cols;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading collections: $e')),
        );
      }
    }
  }

  Future<void> _createCollection() async {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    Uint8List? pickedImageBytes;
    String? pickedImageBase64;

    final created = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFFFF7EC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Create New Collection',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF231408),
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Collection Title',
                          hintText: 'e.g., Khmer New Year Specials',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: descCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Short summary of the collection...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Image picker area
                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                            maxWidth: 800,
                          );
                          if (picked != null) {
                            final bytes = await picked.readAsBytes();
                            setDialogState(() {
                              pickedImageBytes = bytes;
                              pickedImageBase64 = base64Encode(bytes);
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFEAD5A8),
                              width: 1.5,
                            ),
                          ),
                          child: pickedImageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.memory(
                                        pickedImageBytes!,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: GestureDetector(
                                          onTap: () {
                                            setDialogState(() {
                                              pickedImageBytes = null;
                                              pickedImageBase64 = null;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Color(0xCC000000),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 36,
                                      color: Color(0xFF8C6500),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap to upload cover image',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF9E7E5A),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
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
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    try {
                      await AdminApi.createCollection(
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                        coverImage: pickedImageBase64,
                      );
                      if (context.mounted) Navigator.of(context).pop(true);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to create collection: $e')),
                        );
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF8C6500),
                  ),
                  child: Text(
                    'Create',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (created == true) {
      _loadCollections();
    }
  }

  Future<void> _deleteCollection(String id, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFF7EC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete Collection?',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF231408),
            ),
          ),
          content: Text(
            'Are you sure you want to delete "$title"? This will not delete the products themselves, just the collection link.',
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

    if (confirm == true) {
      try {
        await AdminApi.deleteCollection(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Collection deleted successfully')),
        );
        _loadCollections();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete collection: $e')),
        );
      }
    }
  }

  void _manageProducts(Map<String, dynamic> col) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFF7EC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return _ManageCollectionProductsSheet(
          collectionId: col['_id']?.toString() ?? col['id']?.toString() ?? '',
          collectionTitle: col['title']?.toString() ?? '',
          onChanged: _loadCollections,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8C6500),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Collections',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF231408),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Create special curated categories (like Khmer New Year) and add products to them.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF9E7E5A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _createCollection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8C6500),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text(
                    'New Collection',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_collections.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEDE1CB)),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.folder_open_rounded,
                      size: 48,
                      color: Color(0xFF9E7E5A),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No collections yet',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF231408),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Click "New Collection" to create your first collection.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF9E7E5A),
                      ),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _collections.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width >= 900 ? 3 : (MediaQuery.of(context).size.width >= 600 ? 2 : 1),
                  mainAxisExtent: 160,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                ),
                itemBuilder: (context, index) {
                  final col = _collections[index] as Map<String, dynamic>;
                  final colId = col['_id']?.toString() ?? col['id']?.toString() ?? '';
                  final title = col['title']?.toString() ?? 'Unnamed Collection';
                  final desc = col['description']?.toString() ?? 'No description provided';
                  final coverUrl = col['cover_image']?.toString() ?? '';

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEDE1CB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF231408),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _deleteCollection(colId, title),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Color(0xFFC0392B),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            desc,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF6F5B46),
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            OutlinedButton.icon(
                              onPressed: () => _manageProducts(col),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFEAD5A8)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              ),
                              icon: const Icon(
                                Icons.settings_applications_rounded,
                                size: 16,
                                color: Color(0xFF8C6500),
                              ),
                              label: Text(
                                'Manage Products',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF8C6500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ManageCollectionProductsSheet extends StatefulWidget {
  const _ManageCollectionProductsSheet({
    required this.collectionId,
    required this.collectionTitle,
    required this.onChanged,
  });

  final String collectionId;
  final String collectionTitle;
  final VoidCallback onChanged;

  @override
  State<_ManageCollectionProductsSheet> createState() => _ManageCollectionProductsSheetState();
}

class _ManageCollectionProductsSheetState extends State<_ManageCollectionProductsSheet> {
  bool _isLoading = true;
  List<dynamic> _currentProducts = [];
  AdminProduct? _selectedProductToAdd;

  @override
  void initState() {
    super.initState();
    _loadCollectionDetails();
  }

  Future<void> _loadCollectionDetails() async {
    setState(() => _isLoading = true);
    try {
      final details = await AdminApi.fetchCollectionDetails(widget.collectionId);
      final products = details['products'] as List<dynamic>? ?? [];
      if (mounted) {
        setState(() {
          _currentProducts = products;
          _isLoading = false;
          _selectedProductToAdd = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading collection details: $e')),
        );
      }
    }
  }

  Future<void> _addProduct() async {
    if (_selectedProductToAdd == null) return;
    try {
      await AdminApi.addProductToCollection(widget.collectionId, _selectedProductToAdd!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added to collection')),
      );
      widget.onChanged();
      _loadCollectionDetails();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }
  }

  Future<void> _removeProduct(String productId) async {
    try {
      await AdminApi.removeProductFromCollection(widget.collectionId, productId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product removed from collection')),
      );
      widget.onChanged();
      _loadCollectionDetails();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out products already in this collection
    final existingIds = _currentProducts.map((p) => p['_id']?.toString() ?? p['id']?.toString()).toSet();
    final availableProducts = adminProducts.where((p) => !existingIds.contains(p.id)).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 18,
        left: 18,
        right: 18,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.collectionTitle,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF231408),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const Divider(height: 20),
            
            // Add Product Section
            Text(
              'Add Product to Collection',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF231408),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEAD5A8)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<AdminProduct>(
                        value: _selectedProductToAdd,
                        hint: Text(
                          availableProducts.isEmpty ? 'No more products to add' : 'Select a product',
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                        ),
                        isExpanded: true,
                        items: availableProducts.map((p) {
                          return DropdownMenuItem<AdminProduct>(
                            value: p,
                            child: Text(
                              '${p.name} (\$${p.price.toStringAsFixed(2)})',
                              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF231408)),
                            ),
                          );
                        }).toList(),
                        onChanged: availableProducts.isEmpty
                            ? null
                            : (val) => setState(() => _selectedProductToAdd = val),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _selectedProductToAdd == null ? null : _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8C6500),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFE2D3BE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  child: Text(
                    'Add',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Current Products List
            Text(
              'Products in Collection (${_currentProducts.length})',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF231408),
              ),
            ),
            const SizedBox(height: 10),
            
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF8C6500)))
                  : _currentProducts.isEmpty
                      ? Center(
                          child: Text(
                            'No products in this collection.',
                            style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _currentProducts.length,
                          itemBuilder: (context, index) {
                            final product = _currentProducts[index] as Map<String, dynamic>;
                            final pId = product['_id']?.toString() ?? product['id']?.toString() ?? '';
                            final name = product['name']?.toString() ?? 'Unnamed Product';
                            final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0.0;
                            final artisan = product['artisan_id'] is Map ? (product['artisan_id']['shop_name']?.toString() ?? 'Artisan') : 'Artisan';
                            final coverImg = product['image']?.toString() ?? '';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFEDE1CB)),
                              ),
                              child: Row(
                                children: [
                                  if (coverImg.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        coverImg,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 48,
                                          height: 48,
                                          color: const Color(0xFFF1E7D5),
                                          child: const Icon(Icons.image, size: 20, color: Color(0xFF8C6500)),
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1E7D5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.image, size: 20, color: Color(0xFF8C6500)),
                                    ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF231408),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'by $artisan  •  \$${price.toStringAsFixed(2)}',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: const Color(0xFF9E7E5A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _removeProduct(pId),
                                    icon: const Icon(
                                      Icons.remove_circle_outline_rounded,
                                      color: Color(0xFFC0392B),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
