import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';

part 'tonality_model.freezed.dart';
part 'tonality_model.g.dart';

@Freezed()
class SongKey with _$SongKey {
  const factory SongKey({
    String? name,
    ChordsEnum? chord,
    bool? isSharp,
    bool? isMajor,
  }) = _SongKey;

  factory SongKey.fromString(String? keyString) {
    if (keyString == null || keyString.isEmpty) {
      return const SongKey(name: 'Default Key');
    }

    final isSharp = keyString.endsWith('#');
    final chordEnum = ChordsEnum.values.firstWhere(
      (chord) => chord.name == keyString.replaceAll('#', ''),
      orElse: () => ChordsEnum.C,
    );
    final isMajor = !keyString.contains('m');

    return SongKey(
      name: keyString,
      chord: chordEnum,
      isSharp: isSharp,
      isMajor: isMajor,
    );
  }

  factory SongKey.fromJson(Map<String, dynamic> json) =>
      _$SongKeyFromJson(json);
}
