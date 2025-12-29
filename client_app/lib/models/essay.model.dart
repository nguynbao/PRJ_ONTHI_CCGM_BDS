class EssayModel {
  final String id;
  final int rawIndex;
  final String content;
  final List<String> keywords;
  final String group;
  final String category;
  final bool isVerified;

  EssayModel({
    required this.id,
    required this.rawIndex,
    required this.content,
    required this.keywords,
    required this.group,
    required this.category,
    this.isVerified = false,
  });

  factory EssayModel.fromFirestore(Map<String, dynamic> json, String documentId) {
    return EssayModel(
      id: documentId,
      rawIndex: json['rawIndex'] ?? 0,
      content: json['content'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      group: json['group'] ?? 'Kiến thức cơ sở',
      category: json['category'] ?? 'Chung',
      isVerified: json['isVerified'] ?? false,
    );
  }
}