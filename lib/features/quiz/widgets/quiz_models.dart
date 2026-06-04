class QuizQuestion {
  final String key;
  final String prompt;
  final String emoji;
  final String subtitle;
  final List<QuizOption> options;

  const QuizQuestion({
    required this.key,
    required this.prompt,
    required this.emoji,
    required this.subtitle,
    required this.options,
  });
}

class QuizOption {
  final String label;
  final String emoji;
  final String value;

  const QuizOption(this.label, this.emoji, this.value);
}

const quizQuestions = [
  QuizQuestion(
    key: 'occasion',
    prompt: 'What is the occasion?',
    emoji: '🎉',
    subtitle: 'Help us find the perfect cultural gift',
    options: [
      QuizOption('Wedding', '💍', 'Wedding'),
      QuizOption('Khmer New Year', '🎊', 'Khmer New Year'),
      QuizOption('Birthday', '🎂', 'Birthday'),
      QuizOption('Travel Souvenir', '✈️', 'Tourist'),
    ],
  ),
  QuizQuestion(
    key: 'recipient',
    prompt: 'Who is the gift for?',
    emoji: '👤',
    subtitle: 'We\'ll tailor our recommendations',
    options: [
      QuizOption('For Her', '👩', 'For Her'),
      QuizOption('For Him', '👨', 'For Him'),
      QuizOption('For a Couple', '👫', 'Wedding'),
      QuizOption('For Anyone', '🎁', 'Tourist'),
    ],
  ),
  QuizQuestion(
    key: 'category',
    prompt: 'Preferred craft type?',
    emoji: '🏺',
    subtitle: 'Choose the type of handmade gift',
    options: [
      QuizOption('Silk & Textile', '🧵', 'Silk'),
      QuizOption('Silver & Jewelry', '💎', 'Silver'),
      QuizOption('Wood & Ceramics', '🪵', 'Wood'),
      QuizOption('Artisan Food', '🫙', 'Edible'),
    ],
  ),
  QuizQuestion(
    key: 'budget',
    prompt: 'What is your budget?',
    emoji: '💰',
    subtitle: 'We have something for every price range',
    options: [
      QuizOption('Under \$25', '💚', 'low'),
      QuizOption('\$25 – \$50', '💛', 'mid'),
      QuizOption('\$50 – \$100', '🧡', 'high'),
      QuizOption('Over \$100', '❤️', 'premium'),
    ],
  ),
];