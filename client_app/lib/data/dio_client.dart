import 'package:client_app/config/app_config.dart';
import 'package:client_app/data/local/token_storage.dart';
import 'package:dio/dio.dart';


class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 12),
    contentType: 'application/json',
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // TODO: lấy token từ secure storage nếu có
        final token = await TokenStorage.read();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        // log ngắn
        // debugPrint('Dio error: ${e.message}');
        return handler.next(e);
      },
    ));

  static Dio get instance => _dio;
}
