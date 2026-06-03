import 'package:flutter/material.dart';
import '../../data/home_mock_data.dart';
import 'widgets/quiz_models.dart';
import 'widgets/quiz_question_view.dart';
import 'widgets/quiz_results_view.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _step = 0;
  final Map<String, String> _answers = {};
  List<GiftItem>? _results;

  void _pick(String value) {
    final key = quizQuestions[_step].key;
    setState(() => _answers[key] = value);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (_step < quizQuestions.length - 1) {
        setState(() => _step++);
      } else {
        _buildResults();
      }
    });
  }

  void _buildResults() {
    final budget = _answers['budget'] ?? 'mid';
    final category = _answers['category'] ?? '';

    final maxPrice = switch (budget) {
      'low' => 25.0,
      'mid' => 50.0,
      'high' => 100.0,
      'premium' => 9999.0,
      _ => 9999.0,
    };

    final catKeyword = switch (category) {
      'Silk' => 'silk',
      'Silver' => 'silver',
      'Wood' => 'wood',
      'Edible' => 'pepper',
      _ => '',
    };

    var filtered = trendingGifts.where((g) {
      final price =
          double.tryParse(g.price.replaceAll('\$', '').replaceAll(',', '')) ??
              0;
      return price <= maxPrice;
    }).toList();

    if (filtered.isEmpty) filtered = trendingGifts.toList();

    setState(() => _results = filtered);
  }

  void _reset() {
    setState(() {
      _step = 0;
      _answers.clear();
      _results = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF6EE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded,
              color: Color(0xFF231408), size: 26),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Gift Finder Quiz',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF231408),
          ),
        ),
        centerTitle: true,
      ),
      body: _results != null
          ? QuizResultsView(
              results: _results!,
              answers: _answers,
              onRetake: _reset,
            )
          : QuizQuestionView(
              questions: quizQuestions,
              step: _step,
              answers: _answers,
              onPick: _pick,
              onBack: _step > 0 ? () => setState(() => _step--) : null,
            ),
    );
  }
}