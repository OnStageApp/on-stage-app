import 'package:freezed_annotation/freezed_annotation.dart';

part 'song_config.freezed.dart';
part 'song_config.g.dart';

@Freezed()
class SongConfig with _$SongConfig {
  const factory SongConfig() = _SongConfig;

  factory SongConfig.fromJson(Map<String, dynamic> json) =>
      _$SongConfigFromJson(json);
}
