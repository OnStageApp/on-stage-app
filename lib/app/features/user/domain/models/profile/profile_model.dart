import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@Freezed()
class Profile with _$Profile {
  const factory Profile({
    required List<SongOverview> favoriteSongs,
    required List<String> friendsId,
    required String profileImage,
    required String name,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
