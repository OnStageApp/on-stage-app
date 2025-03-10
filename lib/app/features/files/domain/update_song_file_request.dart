import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_song_file_request.freezed.dart';
part 'update_song_file_request.g.dart';

@freezed
class UpdateSongFileRequest with _$UpdateSongFileRequest {
  const factory UpdateSongFileRequest({
    String? name,
    String? link,
  }) = _UpdateSongFileRequest;

  factory UpdateSongFileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSongFileRequestFromJson(json);
}
