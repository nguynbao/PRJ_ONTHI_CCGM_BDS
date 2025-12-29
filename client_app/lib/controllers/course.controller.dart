import 'package:client_app/controllers/exam.controller.dart';
import 'package:client_app/models/topic.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.model.dart';

class CourseController {
  final FirebaseFirestore _db;
  final ExamController _examCtrl;

 CourseController({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance,
        _examCtrl = ExamController(firestore: firestore); // Khởi tạo
  CollectionReference<Map<String, dynamic>> get _coursesCol =>
      _db.collection('courses');

  Future<List<Course>> getAllCourses() async {
    final snapshot = await _coursesCol
        .orderBy('createdAt', descending: false) 
        .get();

    return snapshot.docs
        .map((doc) => Course.fromFirestore(doc))
        .toList();
  }
   Future<List<Topic>> getTopicsByCourse(String courseId) async {
    final topicsRef = _coursesCol.doc(courseId).collection('topics');

    final snapshot = await topicsRef
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => Topic.fromFirestore(doc, courseId: courseId))
        .toList();
  }
  Stream<List<Course>> watchAllCourses() {
    return _coursesCol
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (query) => query.docs
              .map((doc) => Course.fromFirestore(doc))
              .toList(),
        );
  }

Future<Topic?> getTopicDocument({
    required String courseId,
    required String topicId,
  }) async {
    try {
      final topicDocRef = _db.collection('courses').doc(courseId).collection('topics').doc(topicId);
      final snapshot = await topicDocRef.get();

      if (!snapshot.exists) {
        return null;
      }
      return Topic.fromFirestore(snapshot); // Trả về toàn bộ Topic Model
      
    } catch (e) {
      print("Lỗi khi lấy Topic Document: $e");
      return null;
    }
  }
  // Phương thức MỚI: Lấy Khóa học có Exam
  Future<List<Course>> getCoursesWithExams() async {
    final allCourses = await getAllCourses();
    final List<Course> coursesWithExams = [];

    // Duyệt qua từng Course và kiểm tra xem có Exam nào không
    for (var course in allCourses) {
      final hasExams = await _examCtrl.hasExamsInCourse(course.id);
      if (hasExams) {
        coursesWithExams.add(course);
      }
    }

    return coursesWithExams;
  }
  Future<List<Map<String, dynamic>>> getCoursesWithFirstExamInfo() async {
    final allCourses = await getAllCourses();
    final List<Map<String, dynamic>> results = [];

    for (var course in allCourses) {
      final examName = await _examCtrl.getFirstExamName(course.id);
    
      results.add({
        'courseId': course.id,
        'courseName': course.name,
        'name': examName,
      });
        }

    return results;
  }
}
  
