import 'package:flutter/material.dart';

class QuizProgressBar extends StatelessWidget {
  const QuizProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  final int totalSteps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < totalSteps; i++) ...[
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= currentStep
                        ? const Color(0xFFB8770D)
                        : const Color(0xFFEAD5A8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (i < totalSteps - 1) const SizedBox(width: 4),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Question ${currentStep + 1} of $totalSteps',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9E7E5A),
          ),
        ),
      ],
    );
  }
}