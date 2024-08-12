import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_stage_app/logger.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor(this.storage);

  final FlutterSecureStorage storage;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read(key: 'token');

    if (token != null) {
      logger.i('Token: $token');
      options.headers['Authorization'] = 'Bearer $token';
    }
    // options.headers['Content-Type'] = 'application/json';
    return handler.next(options);
  }
}
