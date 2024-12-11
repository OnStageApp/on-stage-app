import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_stage_app/app/features/song/domain/enums/text_size.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/user_settings/data/user_settings_repository.dart';
import 'package:on_stage_app/app/features/user_settings/domain/user_settings.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/shared/utils.dart';
import 'package:on_stage_app/app/utils/shared_prefs/shared_prefs_provider.dart';
import 'package:on_stage_app/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_settings_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserSettingsNotifier extends _$UserSettingsNotifier {
  UserSettingsRepository? _userSettingsRepository;
  static const String _darkModeKey = 'isDarkMode';
  static const String _songViewKey = 'songView';
  static const String _notificationEnabledKey = 'isNotificationEnabled';
  static const String _isOnboardingDone = 'isOnboardingDone';
  static const String _textSizeKey = 'textSize';

  UserSettingsRepository get userSettingsRepository {
    _userSettingsRepository ??= UserSettingsRepository(ref.watch(dioProvider));
    return _userSettingsRepository!;
  }

  SharedPreferences? _prefs;

  SharedPreferences get prefs {
    _prefs ??= ref.read(sharedPreferencesProvider);
    return _prefs!;
  }

  @override
  UserSettings build() {
    return const UserSettings();
  }

  Future<void> init() async {
    if (state.id != null) return;
    logger.i('Initializing userSettings provider state');
    await _loadLocalSettings();

    if (state.isDarkMode != null) {
      _updateSystemOverlay(state.isDarkMode!);
    }
  }

  Future<bool> requestNotificationPermission(BuildContext context) async {
    final status = await Permission.notification.status;

    if (!status.isGranted) {
      await requestPermission(
        permission: Permission.notification,
        context: context,
        onSettingsOpen: () => openSettings(context),
      );
    }

    final updatedStatus = await Permission.notification.status;
    final isGranted = updatedStatus.isGranted;

    await setNotification(isActive: isGranted);

    return isGranted;
  }

  Future<void> resetState() async {
    try {
      const resetSettings = UserSettings();
      final updatedSettings = await userSettingsRepository.updateUserSettings(
        userSettings: resetSettings,
      );
      state = updatedSettings;
      _saveSettingsToPrefs(updatedSettings);
    } catch (e) {
      logger.e('Error resetting user settings: $e');
    }
  }

  Future<void> getUserSettings() async {
    try {
      final userSettings = await userSettingsRepository.getUserSettings();
      state = userSettings;
      _saveSettingsToPrefs(userSettings);
    } catch (e) {
      logger.e('Error fetching user settings: $e');
    }
  }

  Future<void> updateSongView(SongViewMode songView) async {
    try {
      state = state.copyWith(songView: songView);
      final userSettings = UserSettings(songView: songView);
      await userSettingsRepository.updateUserSettings(
        userSettings: userSettings,
      );

      _saveSettingsToPrefs(userSettings);
    } catch (e) {
      logger.e('Error updating song view: $e');
    }
  }

  Future<void> toggleDarkMode({required bool isDarkMode}) async {
    try {
      state = state.copyWith(isDarkMode: isDarkMode);
      final userSettings = UserSettings(isDarkMode: isDarkMode);
      await userSettingsRepository.updateUserSettings(
        userSettings: userSettings,
      );

      _saveSettingsToPrefs(userSettings);
      _updateSystemOverlay(isDarkMode);
    } catch (e) {
      logger.e('Error toggling dark mode: $e');
    }
  }

  Future<void> setNotification({bool isActive = true}) async {
    try {
      final userSettings = UserSettings(isNotificationsEnabled: isActive);
      state = state.copyWith(
        isNotificationsEnabled: isActive,
      );

      await userSettingsRepository.updateUserSettings(
        userSettings: userSettings,
      );

      _saveSettingsToPrefs(userSettings);
    } catch (e) {
      logger.e('Error setting notification: $e');
    }
  }

  Future<void> setTextSize(TextSize textSize) async {
    try {
      final userSettings = UserSettings(textSize: textSize);
      state = state.copyWith(
        textSize: textSize,
      );

      await userSettingsRepository.updateUserSettings(
        userSettings: userSettings,
      );

      _saveSettingsToPrefs(userSettings);
    } catch (e) {
      logger.e('Error setting text size: $e');
    }
  }

  Future<void> setSongViewMode(SongViewMode songView) async {
    try {
      final userSettings = UserSettings(songView: songView);
      state = state.copyWith(
        songView: songView,
      );

      await userSettingsRepository.updateUserSettings(
        userSettings: userSettings,
      );

      _saveSettingsToPrefs(userSettings);
    } catch (e) {
      logger.e('Error setting song view mode: $e');
    }
  }

  Future<void> setOnboardingDone() async {
    try {
      const userSettings = UserSettings(isOnboardingDone: true);
      state = state.copyWith(
        isOnboardingDone: true,
      );

      await userSettingsRepository.updateUserSettings(
        userSettings: userSettings,
      );

      _saveSettingsToPrefs(userSettings);
    } catch (e) {
      logger.e('Error setting onboarding done: $e');
    }
  }

  Future<void> updateUserSettings(UserSettings userSettings) async {
    try {
      await userSettingsRepository.updateUserSettings(
        userSettings: userSettings,
      );

      _saveSettingsToPrefs(userSettings);
    } catch (e) {
      logger.e('Error updating user settings: $e');
    }
  }

  Future<void> _loadLocalSettings() async {
    final isDarkMode = prefs.getBool(_darkModeKey);
    final songViewIndex = prefs.getInt(_songViewKey);
    final isNotificationEnabled = prefs.getBool(_notificationEnabledKey);
    final isOnboardingDone =
        ref.read(sharedPreferencesProvider).getBool(_isOnboardingDone);
    final textSizeIndex = prefs.getInt(_textSizeKey);

    state = state.copyWith(
      isDarkMode: isDarkMode,
      songView: songViewIndex != null
          ? SongViewMode.values[songViewIndex]
          : SongViewMode.american,
      isNotificationsEnabled: isNotificationEnabled,
      isOnboardingDone: isOnboardingDone,
      textSize: textSizeIndex != null
          ? TextSize.values[textSizeIndex]
          : TextSize.normal,
    );

    await getUserSettings();
  }

  void _saveSettingsToPrefs(UserSettings settings) {
    if (settings.isDarkMode != null) {
      prefs.setBool(_darkModeKey, settings.isDarkMode!);
    }
    if (settings.songView != null) {
      prefs.setInt(_songViewKey, settings.songView!.index);
    }
    if (settings.isNotificationsEnabled != null) {
      prefs.setBool(_notificationEnabledKey, settings.isNotificationsEnabled!);
    }
    if (settings.isOnboardingDone != null) {
      ref
          .read(sharedPreferencesProvider)
          .setBool(_isOnboardingDone, settings.isOnboardingDone!);
    }
    if (settings.textSize != null) {
      prefs.setInt(_textSizeKey, settings.textSize!.index);
    }
    if (settings.isCreateEventTooltipShown != null) {
      prefs.setBool(
        'isCreateEventTooltipShown',
        settings.isCreateEventTooltipShown!,
      );
    }
    if (settings.isAddRemindersTooltipShown != null) {
      prefs.setBool(
        'isAddRemindersTooltipShown',
        settings.isAddRemindersTooltipShown!,
      );
    }
  }

  void _updateSystemOverlay(bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: !isDarkMode ? Brightness.light : Brightness.dark,
        statusBarIconBrightness:
            !isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            isDarkMode ? const Color(0xFF1A1C1E) : Colors.white,
        systemNavigationBarIconBrightness:
            !isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
