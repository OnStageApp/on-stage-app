import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_s3_client.g.dart';

@riverpod
Dio dioS3(DioS3Ref ref) {
  final dio = Dio(
    BaseOptions(
      headers: {},
    ),
  );
  final prettyDioLogger = PrettyDioLogger(
    requestHeader: true,
    responseBody: false,
    requestBody: true,
    responseHeader: true,
  );

  dio.interceptors.add(prettyDioLogger);

  return dio;
}