import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_stage_app/app/shared/data/interceptors/logger_interceptor.dart';
import 'package:on_stage_app/app/shared/data/interceptors/token_interceptor.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: API.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
  const storage = FlutterSecureStorage();

  dio.interceptors.add(TokenInterceptor(storage));
  dio.interceptors.add(LoggerInterceptor());

  return dio;
}
