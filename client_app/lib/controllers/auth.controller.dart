import 'package:client_app/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel _mapFirebaseUserToModel(User? user) {
    if (user == null) {
      throw Exception('Firebase User is null after successful operation.');
    }
    return UserModel.fromFirebaseUser(user);
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String userName,
    required DateTime bod,
    required String phone,
    required String gender,
  }) async {
    try {
      // 1. Tạo account trên Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Không lấy được thông tin người dùng sau khi đăng ký.');
      }

      final uid = firebaseUser.uid;
      debugPrint('Đăng ký thành công: Email $email, UID $uid');

      // 2. Lưu thông tin người dùng vào Firestore (collection: users)
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'userName': userName,
        'phone': phone,
        'gender': gender,
        'bod': Timestamp.fromDate(bod),      // lưu DateTime thành Timestamp
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('Đã lưu thông tin user vào Firestore cho UID: $uid');

      // 3. Trả về UserModel tùy chỉnh
      return _mapFirebaseUserToModel(firebaseUser);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'Mật khẩu quá yếu (cần ít nhất 6 ký tự).';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email này đã được sử dụng.';
      } else {
        errorMessage = 'Lỗi đăng ký: ${e.message}';
      }
      throw Exception(errorMessage);
    } on FirebaseException catch (e) {
      // Lỗi từ Firestore
      debugPrint('🔥 FIRESTORE ERROR: ${e.code} - ${e.message}');
      throw Exception('Lỗi lưu dữ liệu vào Firestore: ${e.message}');
      
    } catch (e) {
      throw Exception('Lỗi không xác định khi đăng ký: ${e.toString()}');
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Đăng nhập thành công: Email $email, UID ${userCredential.user?.uid}');
    
      return _mapFirebaseUserToModel(userCredential.user);

    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Không tìm thấy người dùng với email này.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Mật khẩu không chính xác.';
      } else {
        errorMessage = 'Lỗi đăng nhập: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Lỗi không xác định khi đăng nhập: ${e.toString()}');
    }
  }

  /// Phương thức Đăng xuất (Sign Out).
  Future<void> signOut() async { 
    await _firebaseAuth.signOut();
  }
}