class FlashcardCard {
  final String id;
  final String question;
  final String answer;

  FlashcardCard({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FlashcardCard.fromMap(String id, Map<String, dynamic> data) {
    return FlashcardCard(
      id: id,
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
