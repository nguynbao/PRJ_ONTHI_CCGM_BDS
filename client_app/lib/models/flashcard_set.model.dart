class FlashcardSet {
  final String id;
  final String title;
  final String subtitle;
  final String difficulty;

  FlashcardSet({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.difficulty,
  });

  factory FlashcardSet.fromMap(String id, Map<String, dynamic> data) {
    return FlashcardSet(
      id: id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      difficulty: data['difficulty'] ?? 'Cơ bản',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'difficulty': difficulty,
    };
  }
}
