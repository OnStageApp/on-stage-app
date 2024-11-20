import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_stage_app/app/features/login/application/token_manager.dart';
import 'package:on_stage_app/app/features/login/domain/auth_response.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/logger.dart';
import 'package:synchronized/synchronized.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor(FlutterSecureStorage storage)
      : _tokenManager = TokenManager(storage);

  final TokenManager _tokenManager;
  final _refreshTokenLock = Lock();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenManager.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      try {
        final newTokens = await _refreshTokenLock.synchronized(() async {
          final refreshToken = await _tokenManager.getRefreshToken();
          if (refreshToken == null) {
            throw DioException(
              requestOptions: err.requestOptions,
              error: 'No refresh token available',
            );
          }

          final dio = Dio(
            BaseOptions(
              baseUrl: API.baseUrl,
              headers: {'Content-Type': 'application/json'},
            ),
          );
          logger.i('refreshToken: $refreshToken');
          final response = await dio.post(
            API.refreshToken,
            data: {'refreshToken': refreshToken},
          );

          return AuthResponse.fromJson(response.data as Map<String, dynamic>);
        });

        // Save new tokens
        await _tokenManager.saveTokens(
          accessToken: newTokens.accessToken,
          refreshToken: newTokens.refreshToken,
        );

        // Retry original request with new token
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';

        final response = await Dio().fetch(options);
        return handler.resolve(response);
      } catch (e) {
        // If refresh fails, clear tokens and propagate error
        logger.i('Failed to refresh token: $e');
        // await _tokenManager.clearTokens();
        return handler.next(err);
      }
    }
    return handler.next(err);
  }
}
