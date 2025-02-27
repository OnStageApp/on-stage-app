import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/remote_configs/beta_testing.dart';
import 'package:on_stage_app/logger.dart';

class RemoteConfigService {
  RemoteConfigService(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  static const _minRequiredVersionKey = 'min_required_version';
  static const _betaTestingKey = 'beta_testing';
  static const _defaultVersion = '1.0.0';
  static const _defaultBetaTesting = '{"teamIds": [], "features": []}';

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await _remoteConfig.setDefaults({
        _minRequiredVersionKey: _defaultVersion,
        _betaTestingKey: _defaultBetaTesting,
      });

      final updated = await _remoteConfig.fetchAndActivate();
      logger.i('Remote config initialized. Updated: $updated');

      _remoteConfig.onConfigUpdated.listen((event) async {
        await _remoteConfig.activate();
        logger.d('Remote config updated. New min version: $minRequiredVersion');
      });
    } catch (e, st) {
      logger.e('Remote config initialization failed', e, st);
    }
  }

  String get minRequiredVersion =>
      _remoteConfig.getString(_minRequiredVersionKey).isEmpty
          ? _defaultVersion
          : _remoteConfig.getString(_minRequiredVersionKey);

  BetaTestingConfig get betaTestingConfig {
    final raw = _remoteConfig.getString(_betaTestingKey);
    if (raw.isEmpty) return BetaTestingConfig(teamIds: []);
    try {
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        return BetaTestingConfig.fromJson(decoded);
      }
    } catch (e) {
      logger.e('Failed to parse beta testing config', e);
    }
    return BetaTestingConfig(teamIds: []);
  }
}

final remoteConfigProvider = Provider<RemoteConfigService>((ref) {
  return RemoteConfigService(FirebaseRemoteConfig.instance);
});
