import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/profile_avatar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialEmail,
    this.initialImage,
  });

  final String initialName;
  final String initialEmail;
  final File? initialImage;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;

  File? _localImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _localImage = widget.initialImage;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

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

  String _buildInitials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return 'G';
    if (words.length == 1) {
      final first = words.first;
      return first.substring(0, first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
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

      final savedImage = await _persistPickedImage(picked);

      if (!mounted) return;
      setState(() {
        _localImage = savedImage;
      });
      _showMessage('Photo selected. Tap Save Changes to keep it.');
    } catch (_) {
      _showMessage(
        'Could not open gallery. Please allow photos permission.',
        isError: true,
      );
    }
  }

  Future<File> _persistPickedImage(XFile picked) async {
    final appDir = await getApplicationDocumentsDirectory();
    final profileDir = Directory('${appDir.path}/profile');
    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }

    final extension = picked.path.contains('.')
        ? picked.path.substring(picked.path.lastIndexOf('.'))
        : '.jpg';
    final fileName =
        'avatar_${DateTime.now().millisecondsSinceEpoch}$extension';
    final savedPath = '${profileDir.path}/$fileName';

    return File(picked.path).copy(savedPath);
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim().toLowerCase();
    final initials = _buildInitials(name);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_initials', initials);

    if (_localImage != null) {
      await prefs.setString('user_avatar_path', _localImage!.path);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final initials = _buildInitials(
      _nameCtrl.text.isEmpty ? 'Guest' : _nameCtrl.text,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFBF6EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
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
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Profile',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF8C6500),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Text(
                          'Update your personal information',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9E7E5A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.manage_accounts_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ProfileAvatar(
                  initials: initials,
                  localFile: _localImage,
                  radius: 50,
                  showEditButton: true,
                  onEditTap: _pickImage,
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _pickImage,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB8770D),
                  ),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text(
                    'Change Profile Photo',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 18),
                _AuthStyledField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  hint: 'Meyhieng San',
                  icon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Name is required';
                    if (text.length < 2) return 'Name is too short';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _AuthStyledField(
                  controller: _emailCtrl,
                  label: 'Email',
                  hint: 'meyhieng@email.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Email is required';
                    final regex = RegExp(
                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                    );
                    if (!regex.hasMatch(text)) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8770D),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(
                        0xFFB8770D,
                      ).withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.3,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
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
}

class _AuthStyledField extends StatelessWidget {
  const _AuthStyledField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF9E7E5A), size: 20),
        filled: true,
        fillColor: Colors.white,
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
          borderSide: const BorderSide(color: Color(0xFFB8770D), width: 1.5),
        ),
      ),
    );
  }
}
