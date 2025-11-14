import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import này không cần thiết trong model

class UserModel {
  final String uid; // 🔥 Thêm UID để lưu ID người dùng
  final String userName;
  final String email;
  final String? password; // Thay đổi thành nullable. Không bao giờ lưu mật khẩu sau Auth.
  final DateTime? bod; // Thay đổi thành nullable, sử dụng DateTime?
  final String? gender; // Thay đổi thành nullable

  // Constructor chính (sử dụng named arguments giúp code dễ đọc hơn)
  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    this.password,
    this.bod,
    this.gender,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      userName: user.displayName ?? '', // Có thể là chuỗi rỗng nếu chưa set
      password: null, 
      bod: null,
      gender: null,
      // Lưu ý: Hàm này chỉ tạo đối tượng cơ bản. Dữ liệu BOD, Gender phải lấy từ Firestore.
    );
  }

  /// ✅ Phương thức chuyển đổi model thành Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'bod': bod?.toIso8601String(),
      'gender': gender,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Phương thức để tạo đối tượng từ Map Firestore (dùng khi đọc dữ liệu)
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String,
      userName: data['userName'] as String,
      email: data['email'] as String,
      bod: data['bod'] != null ? DateTime.tryParse(data['bod']) : null,
      gender: data['gender'] as String?,
      password: null,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, userName: $userName, email: $email, BOD: $bod, gender: $gender)';
  }
}