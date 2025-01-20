import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_song_item_request.freezed.dart';
part 'create_song_item_request.g.dart';

@Freezed()
class CreateSongItemRequest with _$CreateSongItemRequest {
  const factory CreateSongItemRequest({
    required String songId,
    required String songTitle,
    required int index,
  }) = _CreateSongItemRequest;

  factory CreateSongItemRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSongItemRequestFromJson(json);
}
