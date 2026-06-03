import 'package:flutter/material.dart';
import '../../../data/home_mock_data.dart';
import 'quiz_result_card.dart';

class QuizResultsView extends StatelessWidget {
  const QuizResultsView({
    super.key,
    required this.results,
    required this.answers,
    required this.onRetake,
  });

  final List<GiftItem> results;
  final Map<String, String> answers;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '✨ Perfect Gifts For You',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF231408),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${results.length} gifts matched your preferences',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E7E5A),
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: answers.values
                      .map((v) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB8770D).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    const Color(0xFFB8770D).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              v,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFB8770D),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFEAD5A8))),
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4AF37),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFEAD5A8))),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: (results.length / 2).ceil(),
              itemBuilder: (context, rowIndex) {
                final left = rowIndex * 2;
                final right = left + 1;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: QuizResultCard(item: results[left]),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: right < results.length
                              ? QuizResultCard(item: results[right])
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: onRetake,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retake Quiz'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFB8770D),
                  side: const BorderSide(
                      color: Color(0xFFB8770D), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}