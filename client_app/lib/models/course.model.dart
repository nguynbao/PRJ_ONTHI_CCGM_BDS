import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;          
  final String name;        
  final DateTime? createdAt; 

  Course({
    required this.id,
    required this.name,
    this.createdAt,
  });

  factory Course.newCourse(String name) {
    return Course(
      id: '', 
      name: name,
      createdAt: DateTime.now(),
    );
  }

  factory Course.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
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

    return Course(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      createdAt: created,
    );
  }

  Map<String, dynamic> toJson({bool includeCreatedAt = true}) {
    return {
      'name': name,
      if (includeCreatedAt && createdAt != null)
        'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  Course copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
