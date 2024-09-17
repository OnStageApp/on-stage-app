import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_stager_request.freezed.dart';
part 'create_stager_request.g.dart';

@Freezed()
class CreateStagerRequest with _$CreateStagerRequest {
  const factory CreateStagerRequest({
    required List<String> teamMemberIds,
    required String eventId,
  }) = _CreateStagerRequest;

  factory CreateStagerRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateStagerRequestFromJson(json);
}
