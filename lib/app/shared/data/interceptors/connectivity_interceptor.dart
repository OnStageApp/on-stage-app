import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityResults = await Connectivity().checkConnectivity();
    if (connectivityResults.isEmpty ||
        connectivityResults.every(
          (result) => result == ConnectivityResult.none,
        )) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No internet connection',
        ),
      );
    }
    return handler.next(options);
  }
}
