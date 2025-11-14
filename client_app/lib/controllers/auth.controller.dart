import 'package:client_app/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Lớp Controller để xử lý tất cả các thao tác liên quan đến Firebase Authentication.
class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Helper để map Firebase User sang custom UserModel
  UserModel _mapFirebaseUserToModel(User? user) {
    if (user == null) {
      throw Exception('Firebase User is null after successful operation.');
    }
    return UserModel.fromFirebaseUser(user);
  }

  /// Phương thức Đăng ký (Sign Up) người dùng mới.
  ///
  /// Trả về UserModel nếu thành công, hoặc ném ra một ngoại lệ (Exception) nếu thất bại.
  Future<UserModel> register({ // ✅ Trả về UserModel
    required String email,
    required String password, required String userName, required DateTime bod, required String phone, required String gender,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Đăng ký thành công: Email $email, UID ${userCredential.user?.uid}');
      
      // 🔥 Trả về UserModel tùy chỉnh
      return _mapFirebaseUserToModel(userCredential.user);
      
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
    } catch (e) {
      throw Exception('Lỗi không xác định khi đăng ký: ${e.toString()}');
    }
  }

  /// Phương thức Đăng nhập (Sign In) người dùng hiện có.
  ///
  /// Trả về UserModel nếu thành công, hoặc ném ra một ngoại lệ (Exception) nếu thất bại.
  Future<UserModel> signIn({ // ✅ Trả về UserModel
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Đăng nhập thành công: Email $email, UID ${userCredential.user?.uid}');
      
      // 🔥 Trả về UserModel tùy chỉnh
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
  Future<void> signOut() async { // ✅ Chỉ cần trả về Future<void>
    await _firebaseAuth.signOut();
  }
}