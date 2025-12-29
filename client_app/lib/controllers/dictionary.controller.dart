import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dictionary.model.dart';

class DictionaryController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy tất cả thuật ngữ
  Future<List<DictionaryTerm>> getAllTerms() async {
    final snapshot = await _db.collection("dictionary").get();

    return snapshot.docs
        .map((doc) => DictionaryTerm.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Add term
  Future<void> addTerm(DictionaryTerm term) async {
    await _db.collection("dictionary").add(term.toMap());
  }

  // Update term
  Future<void> updateTerm(DictionaryTerm term) async {
    await _db.collection("dictionary").doc(term.id).update(term.toMap());
  }

  // Delete
  Future<void> deleteTerm(String id) async {
    await _db.collection("dictionary").doc(id).delete();
  }
}
