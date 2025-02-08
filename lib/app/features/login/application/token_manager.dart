import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_stage_app/logger.dart';

class TokenManager {
  TokenManager(this._storage);

  final FlutterSecureStorage _storage;
  static const _accessTokenKey = 'token';
  static const _refreshTokenKey = 'refresh_token';

  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      logger.e('Error reading access token: $e');
      await clearTokens();
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}
