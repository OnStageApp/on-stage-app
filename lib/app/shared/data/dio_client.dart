import 'package:dio/dio.dart';
import 'package:on_stage_app/app/shared/data/interceptors/logger_interceptor.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(BaseOptions(baseUrl: API.baseUrl));
  // const storage = FlutterSecureStorage();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ),
  );
  dio.interceptors.add(LoggerInterceptor());

  return dio;
}
