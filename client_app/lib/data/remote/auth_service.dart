import 'package:client_app/data/dio_client.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    // Đổi endpoint theo server của bạn
    final res = await _dio.post(
      '/api/auth/register',
      data: {'email': email, 'password': password},
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Register failed (${res.statusCode})');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return (res.data as Map<String, dynamic>);
    }
    throw Exception('Login failed (${res.statusCode})');
  }
}
