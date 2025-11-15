import 'package:client_app/models/topic.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.model.dart';

class CourseController {
  final FirebaseFirestore _db;

  CourseController({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

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
}
