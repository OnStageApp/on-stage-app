import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/enums/song_view.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@Freezed()
class UserSettings with _$UserSettings {
  const factory UserSettings({
    String? id,
    String? userId,
    SongViewEnum? songView,
    bool? isDarkMode,
    bool? isNotificationsEnabled,
    bool? isOnboardingDone,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
