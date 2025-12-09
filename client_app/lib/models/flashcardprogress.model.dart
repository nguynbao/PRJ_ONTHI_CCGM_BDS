class FlashcardProgress {
  final bool isCompleted;
  final bool isMarked;

  FlashcardProgress({
    required this.isCompleted,
    required this.isMarked,
  });

  factory FlashcardProgress.fromMap(Map<String, dynamic> data) {
    return FlashcardProgress(
      isCompleted: data['isCompleted'] ?? false,
      isMarked: data['isMarked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isCompleted': isCompleted,
      'isMarked': isMarked,
    };
  }
}
