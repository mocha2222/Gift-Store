import 'package:flutter/material.dart';
import '../../data/home_mock_data.dart';
import '../../services/product_api.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _step = 0;
  final Map<String, String> _answers = {};
  List<GiftItem>? _results;
  bool _isLoadingResults = false;

  static const _questions = [
    _Question(
      key:      'occasion',
      prompt:   'What is the occasion?',
      emoji:    '🎉',
      subtitle: 'Help us find the perfect cultural gift',
      options: [
        _Option('Wedding',        '💍', 'Wedding'),
        _Option('Khmer New Year', '🎊', 'Khmer New Year'),
        _Option('Birthday',       '🎂', 'Birthday'),
        _Option('Travel Souvenir','✈️', 'Tourist'),
      ],
    ),
    _Question(
      key:      'recipient',
      prompt:   'Who is the gift for?',
      emoji:    '👤',
      subtitle: 'We\'ll tailor our recommendations',
      options: [
        _Option('For Her',     '👩', 'For Her'),
        _Option('For Him',     '👨', 'For Him'),
        _Option('For a Couple','👫', 'Wedding'),
        _Option('For Anyone',  '🎁', 'Tourist'),
      ],
    ),
    _Question(
      key:      'category',
      prompt:   'Preferred craft type?',
      emoji:    '🏺',
      subtitle: 'Choose the type of handmade gift',
      options: [
        _Option('Silk & Textile',   '🧵', 'Silk'),
        _Option('Silver & Jewelry', '💎', 'Silver'),
        _Option('Wood & Ceramics',  '🪵', 'Wood'),
        _Option('Artisan Food',     '🫙', 'Edible'),
      ],
    ),
    _Question(
      key:      'budget',
      prompt:   'What is your budget?',
      emoji:    '💰',
      subtitle: 'We have something for every price range',
      options: [
        _Option('Under \$25',  '💚', 'low'),
        _Option('\$25 – \$50', '💛', 'mid'),
        _Option('\$50 – \$100','🧡', 'high'),
        _Option('Over \$100',  '❤️', 'premium'),
      ],
    ),
  ];


  void _pick(String value) {
    final key = _questions[_step].key;
    setState(() => _answers[key] = value);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (_step < _questions.length - 1) {
        setState(() => _step++);
      } else {
        _buildResults();
      }
    });
  }

  Future<void> _buildResults() async {
    setState(() => _isLoadingResults = true);
    final budget   = _answers['budget']   ?? 'mid';
    final category = _answers['category'] ?? '';

    final maxPrice = switch (budget) {
      'low'     => 25.0,
      'mid'     => 50.0,
      'high'    => 100.0,
      'premium' => 9999.0,
      _         => 9999.0,
    };

    final catKeyword = switch (category) {
      'Silk'    => 'silk',
      'Silver'  => 'silver',
      'Wood'    => 'wood',
      'Edible'  => 'pepper',
      _         => '',
    };

    try {
      final products = await ProductApi.getProducts();
      var filtered = products.where((g) {
        final price = double.tryParse(
              g.price.replaceAll('\$', '').replaceAll(',', '')) ??
            0;
        return price <= maxPrice;
      }).toList();

      if (filtered.isEmpty) filtered = products.toList();

      if (mounted) {
        setState(() {
          _results = filtered;
          _isLoadingResults = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingResults = false;
        });
      }
    }
  }

  void _reset() {
    setState(() {
      _step    = 0;
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
        title: const Text('Gift Finder Quiz',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF231408),
          )),
        centerTitle: true,
      ),
      body: _isLoadingResults
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFB8770D)))
          : _results != null
              ? _ResultsView(
                  results: _results!,
                  answers: _answers,
                  onRetake: _reset,
                )
              : _QuizView(
                  questions:  _questions,
                  step:       _step,
                  answers:    _answers,
                  onPick:     _pick,
                  onBack:     _step > 0
                      ? () => setState(() => _step--)
                      : null,
                ),
    );
  }
}


class _QuizView extends StatelessWidget {
  const _QuizView({
    required this.questions,
    required this.step,
    required this.answers,
    required this.onPick,
    required this.onBack,
  });

  final List<_Question> questions;
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

            
            Row(children: [
              for (var i = 0; i < questions.length; i++) ...[
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= step
                          ? const Color(0xFFB8770D)
                          : const Color(0xFFEAD5A8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (i < questions.length - 1)
                  const SizedBox(width: 4),
              ],
            ]),
            const SizedBox(height: 10),

            
            Text(
              'Question ${step + 1} of ${questions.length}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9E7E5A),
              ),
            ),
            const SizedBox(height: 24),

            Text(q.emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(q.prompt,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF231408),
                height: 1.2,
                letterSpacing: -0.5,
              )),
            const SizedBox(height: 6),
            Text(q.subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9E7E5A),
              )),
            const SizedBox(height: 28),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                physics: const NeverScrollableScrollPhysics(),
                children: q.options.map((opt) {
                  final isSelected = answers[q.key] == opt.value;
                  return GestureDetector(
                    onTap: () => onPick(opt.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFB8770D)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFB8770D)
                              : const Color(0xFFEAD5A8),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFB8770D)
                                      .withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [
                                const BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                )
                              ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(opt.emoji,
                              style: const TextStyle(fontSize: 34)),
                          const SizedBox(height: 10),
                          Text(opt.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF231408),
                            )),
                        ],
                      ),
                    ),
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

class _ResultsView extends StatelessWidget {
  const _ResultsView({
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
                const Text('✨ Perfect Gifts For You',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF231408),
                    letterSpacing: -0.5,
                  )),
                const SizedBox(height: 4),
                Text(
                  '${results.length} gifts matched your preferences',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E7E5A),
                  )),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: answers.values.map((v) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8770D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFB8770D).withOpacity(0.3)),
                    ),
                    child: Text(v,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB8770D),
                      )),
                  )).toList(),
                ),
                const SizedBox(height: 16),

                Row(children: [
                  const Expanded(
                      child: Divider(color: Color(0xFFEAD5A8))),
                  Container(
                    width: 8, height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD4AF37),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Expanded(
                      child: Divider(color: Color(0xFFEAD5A8))),
                ]),
                const SizedBox(height: 4),
              ],
            ),
          ),

          
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) =>
                  _ResultCard(item: results[index]),
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

class _ResultCard extends StatefulWidget {
  const _ResultCard({required this.item});
  final GiftItem item;
  @override
  State<_ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<_ResultCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              SizedBox(
                height: 130,
                width: double.infinity,
                child: Image.network(
                  widget.item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 130,
                    color: widget.item.accent.withOpacity(0.2),
                  ),
                ),
              ),
              Positioned(
                top: 8, right: 8,
                child: GestureDetector(
                  onTap: () => setState(() => _liked = !_liked),
                  child: Container(
                    width: 32, height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xF0FFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _liked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 16,
                      color: _liked
                          ? const Color(0xFFC0392B)
                          : const Color(0xFF554B44),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8770D),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('✦ Match',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    )),
                ),
              ),
            ]),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF231408),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Row(children: [
                    ...List.generate(5, (i) => Icon(
                      i < 4
                          ? Icons.star_rounded
                          : Icons.star_half_rounded,
                      color: const Color(0xFFF5A623),
                      size: 13,
                    )),
                  ]),
                  const SizedBox(height: 5),
                  Text(widget.item.price,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF8C6500),
                    )),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFD8AE73),
                        foregroundColor: const Color(0xFF4A321B),
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _Question {
  final String key;
  final String prompt;
  final String emoji;
  final String subtitle;
  final List<_Option> options;
  const _Question({
    required this.key,
    required this.prompt,
    required this.emoji,
    required this.subtitle,
    required this.options,
  });
}

class _Option {
  final String label;
  final String emoji;
  final String value;
  const _Option(this.label, this.emoji, this.value);
}
