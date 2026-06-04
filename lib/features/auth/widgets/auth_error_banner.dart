import 'package:flutter/material.dart';

class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: const Color(0xFFC0392B).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline,
              color: Color(0xFFC0392B), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  color: Color(0xFFC0392B), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}