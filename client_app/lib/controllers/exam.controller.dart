import 'package:client_app/models/exam.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/exam_history.model.dart';

class ExamController {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  ExamController({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // 🔥 Lấy User ID hiện tại một cách an toàn
  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _coursesCol =>
      _db.collection('courses');

  // 🔥 Bộ sưu tập mới để lưu lịch sử làm bài
  CollectionReference<Map<String, dynamic>> get _historyCol =>
      _db.collection('exam_history');

  CollectionReference<Map<String, dynamic>> _getExamsCol(String courseId) {
    return _coursesCol.doc(courseId).collection('exams');
  }

  // --- HÀM MỚI: LƯU KẾT QUẢ BÀI LÀM ---
  Future<void> saveExamResult({
    required String examId,
    required int score,
    required int correctCount,
    required int totalQuestions,
    required int timeTakenSeconds,
  }) async {
    final uid = currentUserId;
    if (uid == null) {
      throw Exception("User not logged in. Cannot save exam results.");
    }

    // 🔥 Cần đảm bảo ExamHistory model đã có hàm toMap() như ví dụ trước
    final Map<String, dynamic> resultData = {
      'userId': uid,
      'examId': examId,
      'score': score,
      'correctCount': correctCount,
      'totalQuestions': totalQuestions,
      'timeTakenSeconds': timeTakenSeconds,
      'submissionTime': FieldValue.serverTimestamp(), // Dùng thời gian máy chủ
    };

    await _historyCol.add(resultData);
    print("Kết quả bài thi cho user $uid, exam $examId đã được lưu.");
  }

  // --- HÀM MỚI: LẤY LỊCH SỬ BÀI LÀM CỦA MỘT USER CHO MỘT BÀI THI CỤ THỂ (Dạng Stream) ---
  Stream<List<ExamHistory>> getExamHistoryStream({required String examId}) {
    final uid = currentUserId;
    if (uid == null) {
      return Stream.value([]);
    }

    // Truy vấn lịch sử theo UID và Exam ID
    return _historyCol
        .where('userId', isEqualTo: uid)
        .where('examId', isEqualTo: examId)
        .orderBy('submissionTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ExamHistory.fromMap(doc.id, doc.data()!)) // Cần đảm bảo ExamHistory.fromMap đã có
        .toList());
  }

  Future<Map<String, dynamic>?> getExamQuestions({
    required String courseId,
    required String examId,
  }) async {
    try {
      final examDocRef = _getExamsCol(courseId).doc(examId);
      final snapshot = await examDocRef.get();

      if (!snapshot.exists) {
        print("Exam ID $examId không tồn tại trong Course $courseId.");
        return null;
      }
      
      final data = snapshot.data();
      
      if (data != null && data['questions'] is Map) {
         return Map<String, dynamic>.from(data['questions']);
      }
      
      print("Trường 'questions' không tồn tại hoặc không phải là Map.");
      return null;

    } catch (e) {
      print("Lỗi khi lấy câu hỏi bài thi: $e");
      return null;
    }
  }

  Future<List<Exam>> getExamsByCourse(String courseId) async {
    try {
      final examsRef = _getExamsCol(courseId);
      final snapshot = await examsRef.get();

      return snapshot.docs
          .map((doc) => Exam.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Lỗi khi lấy danh sách bài thi: $e");
      return [];
    }
  }
  Future<bool> hasExamsInCourse(String courseId) async {
    try {
      // Giới hạn kết quả là 1 để tối ưu hóa hiệu suất
      final snapshot = await _getExamsCol(courseId).limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Lỗi kiểm tra bài thi: $e");
      return false;
    }
  }
  Future<String?> getFirstExamName(String courseId) async {
     try {
         // Lấy Document Exam đầu tiên
         final snapshot = await _getExamsCol(courseId)
             .limit(1)
             .get();
             
         if (snapshot.docs.isNotEmpty) {
             final data = snapshot.docs.first.data();
             final examName = data['name'];
             
             if (examName is String) {
                 return examName;
             }
             return null; 
         }
         return null;
     } catch (e) {
         print("Lỗi khi lấy tên bài thi đầu tiên: $e");
         return null;
     }
  }

Future<List<String>> getAllExamNames(String courseId) async {
    try {
      // Lấy tất cả Document trong Subcollection 'exams'
      final snapshot = await _getExamsCol(courseId)
          .get(); 
          
      if (snapshot.docs.isEmpty) {
          return []; // Trả về danh sách rỗng nếu không có bài thi nào
      }
      
      final List<String> examNames = [];
      
      for (var doc in snapshot.docs) {
          final data = doc.data();
          final examName = data['name'];
          
          // Chỉ thêm vào danh sách nếu trường 'name' tồn tại và là String
          if (examName is String && examName.isNotEmpty) {
              examNames.add(examName);
          }
      }
      
      return examNames; 

    } catch (e) {
      print("Lỗi khi lấy tất cả tên bài thi: $e");
      return [];
    }
  }

  Future<Exam?> getExamDetails({
    required String courseId,
    required String examId,
  }) async {
    try {
      final examDocRef = _getExamsCol(courseId).doc(examId);
      final snapshot = await examDocRef.get();

      if (!snapshot.exists || snapshot.data() == null) {
        print("Exam ID $examId không tồn tại trong Course $courseId.");
        return null;
      }

      // Ép kiểu snapshot về DocumentSnapshot<Map<String, dynamic>>
      return Exam.fromFirestore(snapshot as DocumentSnapshot<Map<String, dynamic>>);

    } catch (e) {
      print("Lỗi khi lấy chi tiết bài thi: $e");
      return null;
    }
  }
}