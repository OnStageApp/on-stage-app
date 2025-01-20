import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_items/domain/create_song_item_request.dart';

part 'create_all_song_items_request.freezed.dart';
part 'create_all_song_items_request.g.dart';

@Freezed()
class CreateAllSongItemsRequest with _$CreateAllSongItemsRequest {
  const factory CreateAllSongItemsRequest({
    required String eventId,
    required List<CreateSongItemRequest> songItems,
  }) = _CreateAllSongItemsRequest;

  factory CreateAllSongItemsRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAllSongItemsRequestFromJson(json);
}
