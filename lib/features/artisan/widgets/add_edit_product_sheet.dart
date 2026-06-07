import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'artisan_product_model.dart';

class AddEditProductSheet extends StatefulWidget {
  const AddEditProductSheet({super.key, this.existing});

  final ArtisanProductModel? existing;

  static Future<ArtisanProductModel?> show(
      BuildContext context, {ArtisanProductModel? existing}) {
    return showModalBottomSheet<ArtisanProductModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditProductSheet(existing: existing),
    );
  }

  @override
  State<AddEditProductSheet> createState() => _AddEditProductSheetState();
}

class _AddEditProductSheetState extends State<AddEditProductSheet> {
  final _formKey   = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _category  = artisanCategories.first;
  bool   _isLoading = false;

  Uint8List? _pickedBytes;
  String?    _pickedFileName;
  String?    _existingPath;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _titleCtrl.text = widget.existing!.title;
      _descCtrl.text  = widget.existing!.description;
      _priceCtrl.text = widget.existing!.price.replaceAll('\$', '');
      _category       = widget.existing!.category;
      _existingPath   = widget.existing!.imagePath;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        _pickedBytes    = bytes;
        _pickedFileName = file.name;
        _existingPath   = null;
      });
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFBF6EE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Choose Image Source',
                style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700,
                  color: Color(0xFF231408),
                )),
            const SizedBox(height: 20),
            _SourceTile(
              icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 12),
            _SourceTile(
              icon: Icons.camera_alt_outlined,
              label: 'Take a Photo',
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_pickedBytes != null || _existingPath != null) ...[
              const SizedBox(height: 12),
              _SourceTile(
                icon: Icons.delete_outline_rounded,
                label: 'Remove Image',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _pickedBytes    = null;
                    _pickedFileName = null;
                    _existingPath   = null;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 700));

    final imagePath = (_pickedBytes != null)
        ? (_pickedFileName ?? 'picked_image')
        : (_existingPath ??
            'https://images.unsplash.com/photo-1567361808960-dec9cb578182?w=400&q=80');

    final product = ArtisanProductModel(
      id: widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title:       _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price:       '\$${_priceCtrl.text.trim()}',
      category:    _category,
      imagePath:   imagePath,
      isAvailable: widget.existing?.isAvailable ?? true,
      createdAt:   widget.existing?.createdAt,
      imageBytes:  _pickedBytes,
    );

    if (mounted) Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit  = widget.existing != null;
    final hasImage = _pickedBytes != null || _existingPath != null;

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFBF6EE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 20),
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Text(isEdit ? 'Edit Product' : 'Add New Product',
                    style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800,
                      color: Color(0xFF231408),
                    )),
                const SizedBox(height: 4),
                Text(
                  isEdit
                      ? 'Update your product details below.'
                      : 'Fill in the details to list your product.',
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF9E7E5A)),
                ),
                const SizedBox(height: 24),

                _buildLabel('Product Photo'),
                GestureDetector(
                  onTap: _showImageSourceSheet,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: hasImage
                            ? const Color(0xFFB8770D)
                            : const Color(0xFFEAD5A8),
                        width: hasImage ? 1.5 : 1,
                      ),
                    ),
                    child: hasImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                _pickedBytes != null
                                    ? Image.memory(_pickedBytes!,
                                        fit: BoxFit.cover)
                                    : Image.network(_existingPath!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Container(
                                              color:
                                                  const Color(0xFFF1E7D5))),
                                Positioned(
                                  bottom: 10, right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.55),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.edit_outlined,
                                            color: Colors.white, size: 13),
                                        SizedBox(width: 4),
                                        Text('Change photo',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 52, height: 52,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF1E7D5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Color(0xFFB8770D), size: 26,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text('Tap to add a photo',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF231408),
                                  )),
                              const SizedBox(height: 4),
                              const Text('Gallery or Camera',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9E7E5A),
                                  )),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel('Product Name'),
                _buildField(
                  controller: _titleCtrl,
                  hint: 'e.g. Hand-woven Silk Krama',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter a product name' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('Description'),
                _buildField(
                  controller: _descCtrl,
                  hint: 'Describe the material, origin, story...',
                  maxLines: 3,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('Price (USD)'),
                _buildField(
                  controller: _priceCtrl,
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  prefix: const Text('\$  ',
                      style: TextStyle(color: Color(0xFF9E7E5A))),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter a price';
                    if (double.tryParse(v) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Category'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEAD5A8)),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    items: artisanCategories
                        .map((c) => DropdownMenuItem(
                            value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _category = v ?? _category),
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFB8770D),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white))
                        : Text(
                            isEdit ? 'Save Changes' : 'Add Product',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600,
          color: Color(0xFF231408),
        )),
  );

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    Widget? prefix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: Color(0xFF231408)),
      decoration: InputDecoration(
        hintText: hint,
        prefix: prefix,
        hintStyle:
            const TextStyle(color: Color(0xFF9E7E5A), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEAD5A8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEAD5A8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFB8770D), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC0392B)),
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String   label;
  final VoidCallback onTap;
  final bool     isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFC0392B)
        : const Color(0xFF231408);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDestructive
              ? const Color(0xFFFFEBEB)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive
                ? const Color(0xFFC0392B).withOpacity(0.3)
                : const Color(0xFFEAD5A8),
          ),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600,
                color: color,
              )),
        ]),
      ),
    );
  }
}
