import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/device/data/device_repository.dart';
import 'package:on_stage_app/app/device/domain/device_request/device_request.dart';
import 'package:on_stage_app/app/enums/platform_type.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'device_service.g.dart';

typedef DeviceInfo = ({
  String osVersion,
  PlatformType platformType,
  String deviceId
});

class DeviceService {
  DeviceService(this._deviceRepository) : _deviceInfo = DeviceInfoPlugin();
  static const String _deviceIdKey = 'persistent_device_id';
  final DeviceInfoPlugin _deviceInfo;
  final DeviceRepository _deviceRepository;

  Future<void> verifyDeviceId() async {
    try {
      final deviceInfo = await getDeviceInfo();
      final storedDeviceId = await _getStoredDeviceId();

      if (storedDeviceId == null || storedDeviceId != deviceInfo.deviceId) {
        logger.i('Device ID changed or not stored. '
            'Old: $storedDeviceId, New: ${deviceInfo.deviceId}');

        final packageInfo = await PackageInfo.fromPlatform();

        await _storeDeviceId(deviceInfo.deviceId);

        await _saveDevice(oldDeviceId: storedDeviceId, deviceInfo, packageInfo);
      } else {
        logger.i('Device ID unchanged: $storedDeviceId');
      }
    } catch (e, stackTrace) {
      logger.e('Error verifying device ID', e, stackTrace);
    }
  }

  Future<void> logInDeviceAndSaveDeviceInfo() async {
    try {
      final deviceInfo = await getDeviceInfo();
      final packageInfo = await PackageInfo.fromPlatform();

      await _storeDeviceId(deviceInfo.deviceId);
      logger.i('Device ID stored locally: ${deviceInfo.deviceId}');

      await _loginDevice(deviceInfo, packageInfo);
      logger.i('Device info saved to backend successfully');
    } catch (e, stackTrace) {
      logger.e('Error saving device info', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updatePushToken(String pushToken) async {
    final deviceId = await getDeviceId();
    final deviceRequest =
        DeviceRequest(deviceId: deviceId, pushToken: pushToken);
    unawaited(_deviceRepository.updateDevice(deviceId, deviceRequest));
  }

  Future<DeviceInfo> getDeviceInfo() async {
    if (Platform.isAndroid) {
      return _getAndroidDeviceInfo();
    } else if (Platform.isIOS) {
      return _getIOSDeviceInfo();
    } else if (Platform.isMacOS) {
      return _getMacOSDeviceInfo();
    }

    return (
      deviceId: 'unknown_${DateTime.now().millisecondsSinceEpoch}',
      osVersion: 'unknown',
      platformType: PlatformType.unknown,
    );
  }

  Future<String> getDeviceId() async {
    final deviceInfo = await getDeviceInfo();
    return deviceInfo.deviceId;
  }

  Future<DeviceInfo> _getAndroidDeviceInfo() async {
    try {
      final androidInfo = await _deviceInfo.androidInfo;
      return (
        deviceId: androidInfo.id,
        osVersion: androidInfo.version.release,
        platformType: PlatformType.android,
      );
    } catch (e, stackTrace) {
      logger.e('Error getting Android device info', e, stackTrace);
      rethrow;
    }
  }

  Future<DeviceInfo> _getIOSDeviceInfo() async {
    try {
      final iosInfo = await _deviceInfo.iosInfo;
      final isIpad = await _isIPad(iosInfo);

      return (
        deviceId: iosInfo.identifierForVendor ?? 'unknown_ios',
        osVersion: iosInfo.systemVersion,
        platformType: isIpad ? PlatformType.ipad : PlatformType.ios,
      );
    } catch (e, stackTrace) {
      logger.e('Error getting iOS device info', e, stackTrace);
      rethrow;
    }
  }

  Future<DeviceInfo> _getMacOSDeviceInfo() async {
    try {
      final macOsInfo = await _deviceInfo.macOsInfo;
      final deviceId = macOsInfo.systemGUID ??
          '${macOsInfo.computerName}_${macOsInfo.systemGUID}';

      return (
        deviceId: deviceId,
        osVersion: macOsInfo.osRelease,
        platformType: PlatformType.macos,
      );
    } catch (e, stackTrace) {
      logger.e('Error getting macOS device info', e, stackTrace);
      rethrow;
    }
  }

  Future<void> _saveDevice(
    DeviceInfo deviceInfo,
    PackageInfo packageInfo, {
    String? oldDeviceId,
  }) async {
    try {
      final device = DeviceRequest(
        deviceId: deviceInfo.deviceId,
        platformType: deviceInfo.platformType,
        osVersion: deviceInfo.osVersion,
        appVersion: packageInfo.version,
        buildVersion: packageInfo.buildNumber,
        pushToken: await _getFcmToken(),
      );

      await _deviceRepository.updateDevice(
        oldDeviceId ?? deviceInfo.deviceId,
        device,
      );
    } catch (e, stackTrace) {
      logger.e('Error saving device to backend', e, stackTrace);
      rethrow;
    }
  }

  Future<void> _loginDevice(
    DeviceInfo deviceInfo,
    PackageInfo packageInfo,
  ) async {
    try {
      final pushToken = await _getFcmToken();
      final device = DeviceRequest(
        deviceId: deviceInfo.deviceId,
        platformType: deviceInfo.platformType,
        osVersion: deviceInfo.osVersion,
        appVersion: packageInfo.version,
        buildVersion: packageInfo.buildNumber,
        pushToken: pushToken,
      );

      await _deviceRepository.loginDevice(
        device,
      );
    } catch (e, stackTrace) {
      logger.e('Error saving device to backend', e, stackTrace);
      rethrow;
    }
  }

  Future<bool> _isIPad(IosDeviceInfo iosInfo) async {
    if (iosInfo.model.toLowerCase().contains('ipad')) {
      return true;
    }

    final physicalSize = PlatformDispatcher.instance.views.first.physicalSize;
    final devicePixelRatio =
        PlatformDispatcher.instance.views.first.devicePixelRatio;
    final width = physicalSize.width / devicePixelRatio;

    return width > 768;
  }

  Future<void> updateDevice(
    String deviceId,
    PackageInfo packageInfo, {
    String? oldDeviceId,
  }) async {
    try {
      final deviceInfo = await getDeviceInfo();

      final device = DeviceRequest(
        deviceId: deviceId,
        platformType: deviceInfo.platformType,
        osVersion: deviceInfo.osVersion,
        appVersion: packageInfo.version,
        buildVersion: packageInfo.buildNumber,
        pushToken: await _getFcmToken(),
      );

      await _deviceRepository.updateDevice(oldDeviceId ?? deviceId, device);
      logger.i('Device updated successfully: $deviceId');
    } catch (e, stackTrace) {
      logger.e('Error updating device', e, stackTrace);
      rethrow;
    }
  }

  Future<String?> _getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      logger.w('Unable to get FCM token: $e');
      return null;
    }
  }

  Future<String?> _getStoredDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceIdKey);
  }

  Future<void> _storeDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceIdKey, deviceId);
  }
}

@Riverpod(keepAlive: true)
DeviceService deviceService(DeviceServiceRef ref) {
  final deviceRepository = DeviceRepository(ref.read(dioProvider));
  return DeviceService(deviceRepository);
}
