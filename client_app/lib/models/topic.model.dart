// Topic.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String id;          
  final String name;        
  final Map<String, dynamic> doc; 

  final DateTime? createdAt; 
  final String? courseId;    

  Topic({
    required this.id,
    required this.name,
    required this.doc,
    this.createdAt,
    this.courseId,
  });

  factory Topic.newTopic(String name) {
    return Topic(
      id: '',
      name: name,
      doc: const {}, 
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
    
    final Map<String, dynamic> rawDoc = data['doc'] is Map
        ? Map<String, dynamic>.from(data['doc'])
        : {};

    return Topic(
      id: doc.id,
      name: (data['topicName'] ?? '').toString(),
      doc: rawDoc, 
      createdAt: created,
      courseId: courseId,
    );
  }

  Map<String, dynamic> toJson({bool includeCreatedAt = true}) {  
    return {
      'topicName': name,
      'doc': doc, 
      if (includeCreatedAt && createdAt != null)
        'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  Topic copyWith({
    String? id,
    String? name,
    Map<String, dynamic>? doc, 
    DateTime? createdAt,
    String? courseId,
  }) {
    return Topic(
      id: id ?? this.id,
      name: name ?? this.name,
      doc: doc ?? this.doc,
      createdAt: createdAt ?? this.createdAt,
      courseId: courseId ?? this.courseId,
    );
  }
}