class DictionaryTerm {
  final String id;
  final String term;
  final String definition;

  DictionaryTerm({
    required this.id,
    required this.term,
    required this.definition,
  });

  // Convert từ Firebase doc → model
  factory DictionaryTerm.fromMap(Map<String, dynamic> map, String id) {
    return DictionaryTerm(
      id: id,
      term: map['term'] ?? '',
      definition: map['definition'] ?? '',
    );
  }

  // Convert model → map (khi thêm mới)
  Map<String, dynamic> toMap() {
    return {
      'term': term,
      'definition': definition,
    };
  }
}
