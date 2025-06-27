import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://loc alhost:8000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

static Future<Response> registerUser(String email, String name) {
  final formData = FormData.fromMap({
    'email': email,
    'name': name,
  });

  return _dio.post('/api/users/register', data: formData);
}

  static Future<Response> verifyOtp(String email, String otp) {
    final formData = FormData.fromMap({
      'email': email,
      'otp': otp,
    });

    return _dio.post('/api/users/verify-otp', data: formData);
  }

  static Future<Response> loginUser(String email) {
    final formData = FormData.fromMap({
      'email': email,
    });

    return _dio.post('/api/auth/login', data: formData);
  }
}
