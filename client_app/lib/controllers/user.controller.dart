import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AppUser {
  final String userId;
  final String? userName;
  final String? email;

  AppUser({
    required this.userId,
    this.userName,
    this.email,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String userId) {
    return AppUser(
      userId: userId,
      // Ưu tiên displayName, nếu không có thì dùng userName
      userName: (data['displayName'] ?? data['userName']) as String?,
      email: data['email'] as String?,
    );
  }
}

class UserController {
  static final UserController _instance = UserController._internal();
  factory UserController() => _instance;

  UserController._internal()
      : _auth = FirebaseAuth.instance,
        _db = FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  String? get currentUserId => _auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> _currentUserDoc() {
    final uid = currentUserId;
    if (uid == null) {
      throw Exception('Người dùng chưa đăng nhập.');
    }
    return _db.collection('users').doc(uid);
  }
  Future<String?> getDisplayName() async {
    final uid = currentUserId;

    if (uid == null) {
      debugPrint('getDisplayName: chưa có user đăng nhập.');
      return null;
    }

    try {
      final docRef = _currentUserDoc();
      final docSnap = await docRef.get();


      if (!docSnap.exists) {
        debugPrint('getDisplayName: user $uid chưa có document trong Firestore (collection users).');
        return null;
      }

      final data = docSnap.data();
      debugPrint('getDisplayName: data = $data');

      if (data == null) return null;

      final name = (data['displayName'] ?? data['userName']) as String?;
      if (name != null && name.trim().isNotEmpty) {
        debugPrint('getDisplayName: found name = $name');
        return name.trim();
      }

      debugPrint('getDisplayName: không tìm thấy field displayName hoặc userName hợp lệ.');
      return null;
    } catch (e, stack) {
      debugPrint('🔥 Lỗi khi getDisplayName: $e');
      debugPrint('STACK: $stack');
      return null;
    }
  }

  /// Cập nhật displayName trong Firestore (field "displayName")
  Future<void> updateDisplayName(String newName) async {
    final uid = currentUserId;
    if (uid == null) {
      throw Exception('Người dùng chưa đăng nhập.');
    }

    try {
      await _currentUserDoc().set(
        {
          'displayName': newName,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      debugPrint('✅ updateDisplayName OK cho user $uid');
    } catch (e, stack) {
      debugPrint('🔥 Lỗi khi updateDisplayName: $e');
      debugPrint('STACK: $stack');
      rethrow;
    }
  }

  Future<AppUser?> getProfile() async {
    final uid = currentUserId;
    if (uid == null) return null;

    try {
      final snap = await _currentUserDoc().get();
      if (!snap.exists || snap.data() == null) return null;
      return AppUser.fromFirestore(snap.data()!, uid);
    } catch (e, stack) {
      debugPrint('🔥 Lỗi khi getProfile: $e');
      debugPrint('STACK: $stack');
      return null;
    }
  }
}
