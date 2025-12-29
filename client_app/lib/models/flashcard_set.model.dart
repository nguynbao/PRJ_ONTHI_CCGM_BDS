class FlashcardSet {
  final String id;
  final String title;
  final String subtitle;
  final String difficulty;
  final String creatorId;
  final bool isPublic;

  FlashcardSet({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    this.creatorId = '',
    this.isPublic = true,
  });

  factory FlashcardSet.fromMap(String id, Map<String, dynamic> data) {
    return FlashcardSet(
      id: id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      difficulty: data['difficulty'] ?? 'Dễ',
      creatorId: data['creatorId']  ?? '',
      isPublic: data['isPublic'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'difficulty': difficulty,
      'creatorId': creatorId,
      'isPublic': isPublic,
    };
  }
}
