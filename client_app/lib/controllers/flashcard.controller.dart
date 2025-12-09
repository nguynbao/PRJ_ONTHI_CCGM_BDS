import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/flashcard_card.model.dart';
import '../models/flashcard_set.model.dart';

class FlashcardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy User hiện tại một cách an toàn
  User? get currentUser => FirebaseAuth.instance.currentUser;

  // Lấy UID một cách an toàn (trả về null nếu chưa đăng nhập)
  String? get userId => currentUser?.uid;

  Stream<List<FlashcardSet>> getFlashcardSets() {
    return _db
        .collection('flashcard_sets')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FlashcardSet.fromMap(doc.id, doc.data()))
        .toList());
  }

  Stream<List<FlashcardCard>> getCards(String setId) {
    return _db
        .collection('flashcards')
        .where('setId', isEqualTo: setId)
        .orderBy('question')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FlashcardCard.fromMap(doc.id, doc.data()))
        .toList());
  }

  Future<String> addFlashcardSet(FlashcardSet set) async {
    final uid = userId;
    if (uid == null) throw Exception("User not logged in"); // Yêu cầu đăng nhập

    final doc = await _db.collection('flashcard_sets').add({
      'title': set.title,
      'subtitle': set.subtitle,
      'difficulty': set.difficulty,
      'creatorId': uid, // 🔥 LƯU USER ID TẠO
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> addCard(String setId, FlashcardCard card) async {
    await _db.collection('flashcards').add({
      ...card.toMap(),
      'setId': setId,
    });
  }

  Future<void> updateProgress(
      String cardId, {
        bool? isMarked,
        bool? isCompleted,
      }) async {
    final uid = userId;
    if (uid == null) {
      return;
    }

    Map<String, dynamic> update = {};
    if (isMarked != null) update['isMarked'] = isMarked;
    if (isCompleted != null) update['isCompleted'] = isCompleted;

    await _db
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc(cardId)
        .set(update, SetOptions(merge: true));
  }

  Future<void> toggleSaveSet(String setId) async {
    final uid = userId;
    if (uid == null) return;

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('saved_sets')
        .doc(setId);

    final doc = await ref.get();
    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set({"savedAt": FieldValue.serverTimestamp()});
    }
  }

  // Lấy chi tiết bộ đề dựa trên list ID (từ saved_sets)
  Future<List<FlashcardSet>> getSetsByIds(List<String> setIds) async {
    if (setIds.isEmpty) return [];

    // Lấy tối đa 10 ID do giới hạn của whereIn
    final setsSnapshot = await _db
        .collection('flashcard_sets')
        .where(FieldPath.documentId, whereIn: setIds.take(10).toList())
        .get();

    return setsSnapshot.docs.map((doc) => FlashcardSet.fromMap(doc.id, doc.data())).toList();
  }

  Stream<List<FlashcardSet>> getSetsCreatedBy(String uid) {
    return _db
        .collection('flashcard_sets')
        .where('creatorId', isEqualTo: uid) // 🔥 TRUY VẤN THEO creatorId
    // Cần tạo Index cho trường creatorId trong Firestore
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FlashcardSet.fromMap(doc.id, doc.data()))
        .toList());
  }

  Stream<Map<String, int>> getProgressStreamOfSet(String setId) {
    final uid = userId;
    if (uid == null) {
      return _db
          .collection('flashcards')
          .where('setId', isEqualTo: setId)
          .get() // Đổi từ snapshots() sang get() cho trường hợp Guest
          .asStream() // Chuyển Future sang Stream
          .map((cardsSnapshot) => {
        'total': cardsSnapshot.size,
        'completed': 0,
        'marked': 0,
      });
    }

    final cardsQuery = _db
        .collection('flashcards')
        .where('setId', isEqualTo: setId)
        .get();

    return _db
        .collection('users')
        .doc(uid)
        .collection('progress')
        .snapshots()
        .asyncMap((progressSnapshot) async {

      final cards = await cardsQuery;

      int total = cards.size;
      int completed = 0;
      int marked = 0;

      final progressMap = {
        for (var doc in progressSnapshot.docs)
          doc.id: doc.data(),
      };

      for (var card in cards.docs) {
        final progress = progressMap[card.id];

        if (progress != null) {
          if (progress['isCompleted'] == true) completed++;
          if (progress['isMarked'] == true) marked++;
        }
      }

      return {
        'total': total,
        'completed': completed,
        'marked': marked,
      };
    });
  }

  Future<Map<String, int>> getProgressOfSetFuture(String setId) async {
    final uid = userId;
    if (uid == null) return {'total': 0, 'completed': 0, 'marked': 0};

    // Lấy danh sách card IDs trong bộ đề
    final cards = await _db
        .collection('flashcards')
        .where('setId', isEqualTo: setId)
        .get();

    // Lấy tiến độ của người dùng
    final progressSnapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('progress')
        .get();

    int total = cards.size;
    int completed = 0;
    int marked = 0;

    // Tối ưu hóa việc tìm kiếm tiến độ
    final progressMap = {
      for (var doc in progressSnapshot.docs)
        doc.id: doc.data(),
    };

    for (var card in cards.docs) {
      final progress = progressMap[card.id];
      if (progress != null) {
        if (progress['isCompleted'] == true) completed++;
        if (progress['isMarked'] == true) marked++;
      }
    }

    return {
      'total': total,
      'completed': completed,
      'marked': marked,
    };
  }

// 1. Lấy tất cả sets (Future)
  Future<List<FlashcardSet>> getFlashcardSetsFuture() async {
    final snapshot = await _db.collection('flashcard_sets').get();
    return snapshot.docs.map((doc) => FlashcardSet.fromMap(doc.id, doc.data())).toList();
  }

// 2. Lấy sets đã lưu (Future)
  Future<List<FlashcardSet>> getSavedSetsFuture(String uid) async {
    final savedSnapshot = await _db.collection('users').doc(uid).collection('saved_sets').get();
    final setIds = savedSnapshot.docs.map((e) => e.id).toList();
    if (setIds.isEmpty) return [];

    // Tái sử dụng getSetsByIds (đã có)
    return getSetsByIds(setIds);
  }

// 3. Lấy sets do user tạo (Future)
  Future<List<FlashcardSet>> getSetsCreatedByFuture(String uid) async {
    final snapshot = await _db
        .collection('flashcard_sets')
        .where('creatorId', isEqualTo: uid)
        .get();
    return snapshot.docs.map((doc) => FlashcardSet.fromMap(doc.id, doc.data())).toList();
  }
}