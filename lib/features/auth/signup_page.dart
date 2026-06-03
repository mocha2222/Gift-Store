import 'package:flutter/material.dart';
import '../../router/app_router.dart';
import '../../services/auth_api.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_error_banner.dart';
import 'widgets/auth_submit_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl  = TextEditingController();
  final _formKey      = GlobalKey<FormState>();

  bool _isLoading   = false;
  bool _obscurePass = true;
  bool _obscureConf = true;
  String? _errorMsg;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      final resp = await AuthApi.register(_nameCtrl.text.trim(), _emailCtrl.text.trim().toLowerCase(), _passwordCtrl.text);
      final role = (resp['user']?['role'] ?? 'customer').toString().toLowerCase();
      if (!mounted) return;
      if (role == 'admin') {
        Navigator.of(context).pushReplacementNamed(AppRoutes.admin);
      } else if (role == 'artisan') {
        Navigator.of(context).pushReplacementNamed(AppRoutes.artisan);
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } catch (err) {
      setState(() { _isLoading = false; _errorMsg = 'Could not create account. Try again.'; });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEAD5A8)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Color(0xFF231408), size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF231408),
                            letterSpacing: -0.5,
                          )),
                      Text('Join Khmer Treasures today',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9E7E5A),
                          )),
                    ],
                  ),
                ]),
                const SizedBox(height: 32),

                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                        color: const Color(0xFFD4AF37), width: 2),
                  ),
                  child: const Center(
                    child: Icon(Icons.person_outline,
                        color: Colors.white, size: 32),
                  ),
                ),
                const SizedBox(height: 28),

                if (_errorMsg != null) ...[
                  AuthErrorBanner(message: _errorMsg!),
                  const SizedBox(height: 16),
                ],

                AuthTextField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  hint: 'Meyhieng San',
                  icon: Icons.person_outline,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter your full name';
                    if (v.trim().length < 3) return 'Name must be at least 3 characters';
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v.trim())) {
                      return 'Name can only contain letters and spaces';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  controller: _emailCtrl,
                  label: 'Email',
                  hint: 'meyhieng@email.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your email';
                    final emailRegex = RegExp(
                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                    if (!emailRegex.hasMatch(v.trim())) return 'Please enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  controller: _passwordCtrl,
                  label: 'Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePass,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF9E7E5A), size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter a password';
                    if (v.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                AuthTextField(
                  controller: _confirmCtrl,
                  label: 'Confirm Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscureText: _obscureConf,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConf
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF9E7E5A), size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConf = !_obscureConf),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please confirm your password';
                    if (v != _passwordCtrl.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                AuthSubmitButton(
                  label: 'Create Account',
                  isLoading: _isLoading,
                  onPressed: _signUp,
                ),
                const SizedBox(height: 24),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Already have an account? ',
                      style: TextStyle(
                          color: Color(0xFF9E7E5A), fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text('Sign In',
                        style: TextStyle(
                          color: Color(0xFFB8770D),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ]),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}