import 'package:client_app/models/exam.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamController {
  final FirebaseFirestore _db;

  ExamController({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _coursesCol =>
      _db.collection('courses');

  CollectionReference<Map<String, dynamic>> _getExamsCol(String courseId) {
    return _coursesCol.doc(courseId).collection('exams');
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

      // ✅ Sử dụng Exam.fromFirestore để chuyển đổi DocumentSnapshot thành đối tượng Exam
      // Chúng ta phải ép kiểu snapshot về DocumentSnapshot<Map<String, dynamic>>
      return Exam.fromFirestore(snapshot as DocumentSnapshot<Map<String, dynamic>>);

    } catch (e) {
      print("Lỗi khi lấy chi tiết bài thi: $e");
      return null;
    }
  }

}