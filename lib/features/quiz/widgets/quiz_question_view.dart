import 'package:flutter/material.dart';
import 'quiz_models.dart';
import 'quiz_progress_bar.dart';
import 'quiz_option_tile.dart';

class QuizQuestionView extends StatelessWidget {
  const QuizQuestionView({
    super.key,
    required this.questions,
    required this.step,
    required this.answers,
    required this.onPick,
    required this.onBack,
  });

  final List<QuizQuestion> questions;
  final int step;
  final Map<String, String> answers;
  final ValueChanged<String> onPick;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final q = questions[step];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuizProgressBar(
              totalSteps: questions.length,
              currentStep: step,
            ),
            const SizedBox(height: 24),

            Text(q.emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(
              q.prompt,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF231408),
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              q.subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9E7E5A),
              ),
            ),
            const SizedBox(height: 28),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                physics: const NeverScrollableScrollPhysics(),
                children: q.options.map((opt) {
                  return QuizOptionTile(
                    option: opt,
                    isSelected: answers[q.key] == opt.value,
                    onTap: () => onPick(opt.value),
                  );
                }).toList(),
              ),
            ),

            if (onBack != null) ...[
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const Text('Back'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF9E7E5A),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}