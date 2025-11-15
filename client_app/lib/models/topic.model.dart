import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String id;          
  final String name;        
  final DateTime? createdAt; 
  final String? courseId;    

  Topic({
    required this.id,
    required this.name,
    this.createdAt,
    this.courseId,
  });

  factory Topic.newTopic(String name) {
    return Topic(
      id: '',
      name: name,
      createdAt: DateTime.now(),
    );
  }

  factory Topic.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String? courseId,
  }) {
    final data = doc.data() ?? {};

    final ts = data['createdAt'];
    DateTime? created;
    if (ts is Timestamp) {
      created = ts.toDate();
    } else if (ts is DateTime) {
      created = ts;
    } else {
      created = null;
    }

    return Topic(
      id: doc.id,
      name: (data['topicName'] ?? '').toString(),
      createdAt: created,
      courseId: courseId,
    );
  }

  Map<String, dynamic> toJson({bool includeCreatedAt = true}) {
    return {
      'topicName': name,
      if (includeCreatedAt && createdAt != null)
        'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  Topic copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? courseId,
  }) {
    return Topic(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      courseId: courseId ?? this.courseId,
    );
  }
}
