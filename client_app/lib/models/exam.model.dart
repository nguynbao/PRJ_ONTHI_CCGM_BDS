import 'package:cloud_firestore/cloud_firestore.dart';

class Exam {
  final String id;
  final String name;
  final String courseId;
  final Map<String, dynamic> questions;
  final int durationMinutes;

  Exam({
    required this.id,
    required this.name,
    required this.courseId,
    required this.questions,
    required this.durationMinutes
  });

  factory Exam.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    
    final Map<String, dynamic> rawQuestions = data['questions'] is Map 
        ? Map<String, dynamic>.from(data['questions']) 
        : {};

    final int duration = (data['durationMinutes'] as num? ?? 0).toInt();

    return Exam(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      courseId: (data['courseId'] ?? '').toString(),
      questions: rawQuestions,
      durationMinutes: duration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'courseId': courseId,
      'questions': questions,
      'durationMinutes': durationMinutes,
    };
  }
}