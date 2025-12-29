// lib/models/essay.model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamHistory {
  final String id;
  final String userId;
  final String examId;
  final DateTime submissionTime;
  final int score;
  final int correctCount;
  final int totalQuestions;
  final int timeTakenSeconds;

  ExamHistory({
    required this.id,
    required this.userId,
    required this.examId,
    required this.submissionTime,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
    required this.timeTakenSeconds,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'examId': examId,
      'score': score,
      'correctCount': correctCount,
      'totalQuestions': totalQuestions,
      'timeTakenSeconds': timeTakenSeconds,
    };
  }

  factory ExamHistory.fromMap(String id, Map<String, dynamic> data) {
    return ExamHistory( // Gọi constructor đã định nghĩa ở trên
      id: id,
      userId: data['userId'] as String? ?? '',
      examId: data['examId'] as String? ?? '',
      submissionTime: (data['submissionTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      score: (data['score'] as num? ?? 0).toInt(),
      correctCount: (data['correctCount'] as num? ?? 0).toInt(),
      totalQuestions: (data['totalQuestions'] as num? ?? 0).toInt(),
      timeTakenSeconds: (data['timeTakenSeconds'] as num? ?? 0).toInt(),
    );
  }
}