import 'package:cloud_firestore/cloud_firestore.dart';

class Exam {
  final String id;
  final String name;
  final String courseId;
  
  final Map<String, dynamic> questions; 

  Exam({
    required this.id,
    required this.name,
    required this.courseId,
    required this.questions,
  });

  factory Exam.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    
    final Map<String, dynamic> rawQuestions = data['questions'] is Map 
        ? Map<String, dynamic>.from(data['questions']) 
        : {};

    return Exam(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      courseId: (data['courseId'] ?? '').toString(),
      questions: rawQuestions, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'courseId': courseId,
      'questions': questions, 
    };
  }
}