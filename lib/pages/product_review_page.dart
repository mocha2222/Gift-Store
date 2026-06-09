import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/product_api.dart';

class ProductReviewPage extends StatefulWidget {
  const ProductReviewPage({
    super.key,
    required this.productId,
    required this.productTitle,
  });

  final String productId;
  final String productTitle;

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 5;
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _picker = ImagePicker();
  final List<XFile> _images = [];
  bool _submitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final files = await _picker.pickMultiImage(imageQuality: 75);
    if (files.isEmpty) return;
    setState(() => _images.addAll(files));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final imagesBase64 = <String>[];
      for (final img in _images) {
        final bytes = await img.readAsBytes();
        imagesBase64.add(base64Encode(bytes));
      }

      await ProductApi.submitReview(
        productId: widget.productId,
        rating: _rating,
        title: _titleCtrl.text.trim().isEmpty ? null : _titleCtrl.text.trim(),
        body: _bodyCtrl.text.trim().isEmpty ? null : _bodyCtrl.text.trim(),
        imagesBase64: imagesBase64.isEmpty ? null : imagesBase64,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Review submitted')));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit review: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review — ${widget.productTitle}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'How would you rate this product?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final val = i + 1;
                  return IconButton(
                    onPressed: () => setState(() => _rating = val),
                    icon: Icon(
                      _rating >= val ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 80,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _bodyCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Write your review',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 6,
                      validator: (v) => v == null || v.trim().length < 10
                          ? 'Please write at least 10 characters'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImages,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Add photos'),
                        ),
                        if (_images.isNotEmpty)
                          ..._images.map(
                            (img) => Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Image.file(
                                    File(img.path),
                                    width: 88,
                                    height: 88,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _images.remove(img)),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.black54,
                                      child: Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          _submitting ? 'Submitting...' : 'Submit Review',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
