import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_stage_app/app/shared/data/interceptors/connectivity_interceptor.dart';
import 'package:on_stage_app/app/shared/data/interceptors/permission_interceptor.dart';
import 'package:on_stage_app/app/shared/data/interceptors/token_interceptor.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
Dio dio(Ref ref) {
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
    requestBody: true,
  );

  dio.interceptors.add(TokenInterceptor(storage, ref));
  dio.interceptors.add(prettyDioLogger);
  dio.interceptors.add(ConnectivityInterceptor());
  dio.interceptors.add(PermissionInterceptor(ref));
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) {
        logger
          ..i('Dio Error:')
          ..i('Type: ${e.type}')
          ..i('Message: ${e.message}')
          ..i('Response: ${e.response}');
        return handler.next(e);
      },
    ),
  );

  return dio;
}
