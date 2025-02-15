import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/enums/text_size.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@Freezed()
class UserSettings with _$UserSettings {
  const factory UserSettings({
    String? id,
    String? userId,
    SongViewMode? songView,
    TextSize? textSize,
    bool? isDarkMode,
    bool? displayMdNotes,
    bool? displaySongDetails,
    bool? isNotificationsEnabled,
    bool? isOnboardingDone,
    bool? isCreateEventTooltipShown,
    bool? isAddRemindersTooltipShown,
    bool? isEventTemplatesFeatureWallShown,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
