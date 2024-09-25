import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_stage_app/app/shared/data/interceptors/connectivity_interceptor.dart';
import 'package:on_stage_app/app/shared/data/interceptors/token_interceptor.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
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

  final prettyDioLogger = PrettyDioLogger(
    requestHeader: false,
    requestBody: false,
    responseHeader: false,
    responseBody: false,
  );

  dio.interceptors.add(TokenInterceptor(storage));
  dio.interceptors.add(prettyDioLogger);
  dio.interceptors.add(ConnectivityInterceptor());
  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioError e, ErrorInterceptorHandler handler) {
      print('Dio Error:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');
      return handler.next(e);
    },
  ));

  return dio;
}
