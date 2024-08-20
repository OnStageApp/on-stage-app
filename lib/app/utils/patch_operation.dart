@freezed
class PatchOperation with _$PatchOperation {
  const factory PatchOperation({
    required String op,
    required String path,
    required dynamic value,
  }) = _PatchOperation;

  factory PatchOperation.fromJson(Map<String, dynamic> json) =>
      _$PatchOperationFromJson(json);
}
