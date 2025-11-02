import 'package:client_app/data/dio_client.dart';
import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = DioClient.instance;

   Future<String?> getDisplayName() async {
    final res = await _dio.get('/api/user/me'); // đổi path theo server bạn
    // kỳ vọng { userName: "..." }
    final data = res.data as Map<String, dynamic>?;
    return data?['userName'] as String?;
  }
}