import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/chord_type_enum.dart';

part 'song_key.freezed.dart';
part 'song_key.g.dart';

@Freezed()
class SongKey with _$SongKey {
  const factory SongKey({
    ChordsWithoutSharp? chord,
    @Default(ChordTypeEnum.natural) ChordTypeEnum keyType,
    @Default(true) bool isMajor,
  }) = _SongKey;

  const SongKey._();

  factory SongKey.fromJson(Map<String, dynamic> json) =>
      _$SongKeyFromJson(json);

  String get name {
    if (chord == null) return 'Key not found';

    final suffix = isMajor ? ' major' : ' minor';
    final accidental = switch (keyType) {
      ChordTypeEnum.sharp => '♯',
      ChordTypeEnum.flat => 'b',
      ChordTypeEnum.natural => '',
    };

    return '${chord!.name}$accidental$suffix';
  }
}
