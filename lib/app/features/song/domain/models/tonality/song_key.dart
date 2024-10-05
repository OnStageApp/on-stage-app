import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';

part 'song_key.freezed.dart';
part 'song_key.g.dart';

@Freezed()
class SongKey with _$SongKey {
  const factory SongKey({
    ChordsWithoutSharp? chord,
    @Default(false) bool isSharp,
    @Default(true) bool isMajor,
  }) = _SongKey;

  const SongKey._();

  factory SongKey.fromJson(Map<String, dynamic> json) =>
      _$SongKeyFromJson(json);

  String get name {
    if (chord == null) {
      return 'Key not found';
    }

    var result = chord!.name;
    if (isSharp) {
      result += '#';
    }
    if (!isMajor) {
      result += ' minor';
    } else {
      result += ' major';
    }
    return result;
  }
}
