import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_stager_request.freezed.dart';
part 'create_stager_request.g.dart';

@Freezed()
class CreateStagersRequest with _$CreateStagersRequest {
  const factory CreateStagersRequest({
    required List<String> teamMemberIds,
    required String eventId,
  }) = _CreateStagersRequest;

  factory CreateStagersRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateStagersRequestFromJson(json);
}
