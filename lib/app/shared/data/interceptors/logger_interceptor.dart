import 'package:dio/dio.dart';
import 'package:on_stage_app/logger.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger
      ..i('Request [${options.method}] ${options.path}')
      ..i('Headers: ${options.headers}')
      ..i('Data: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i('Response [${response.statusCode}] ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('Error: ${err.message} ${err.stackTrace}');
    handler.next(err);
  }
}
