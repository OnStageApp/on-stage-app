import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/features/login/application/token_manager.dart';
import 'package:on_stage_app/app/features/login/data/login_repository.dart';
import 'package:on_stage_app/app/features/login/domain/auth_response.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/logger.dart';
import 'package:synchronized/synchronized.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor(
    FlutterSecureStorage storage,
    this._ref,
  ) : _tokenManager = TokenManager(storage);

  final Ref _ref;
  final TokenManager _tokenManager;
  final _refreshTokenLock = Lock();

  LoginRepository get _loginRepository =>
      LoginRepository(_ref.read(dioProvider));

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
    if (err.response?.statusCode == 401) {
      try {
        final newTokens = await _refreshTokenLock.synchronized(() async {
          final refreshToken = await _tokenManager.getRefreshToken();
          if (refreshToken == null) {
            throw DioException(
              requestOptions: err.requestOptions,
              error: 'No refresh token available',
            );
          }
          final response = await _getNewToken(refreshToken);

          return AuthResponse.fromJson(response.data as Map<String, dynamic>);
        });

        await _tokenManager.saveTokens(
          accessToken: newTokens.accessToken,
          refreshToken: newTokens.refreshToken,
        );

        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';

        final response = await Dio().fetch(options);
        return handler.resolve(response);
      } catch (e) {
        logger.i('Failed to refresh token: $e');
        await _tokenManager.clearTokens();
        unawaited(_ref.read(loginNotifierProvider.notifier).signOut());
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

  Future<Response<dynamic>> _getNewToken(String refreshToken) async {
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
    return response;
  }
}

//TODO: Handle sign out if refreshtoken fails
