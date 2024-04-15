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
  }) = _Tonality;

  factory SongKey.fromJson(Map<String, dynamic> json) =>
      _$SongKeyFromJson(json);
}
