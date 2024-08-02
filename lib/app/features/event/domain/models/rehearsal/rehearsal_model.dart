import 'package:freezed_annotation/freezed_annotation.dart';

part 'rehearsal_model.freezed.dart';
part 'rehearsal_model.g.dart';

@Freezed()
class Rehearsal with _$Rehearsal {
  const factory Rehearsal({
    required String? id,
    required String? name,
    required DateTime? dateTime,
  }) = _Rehearsal;

  factory Rehearsal.fromJson(Map<String, dynamic> json) =>
      _$RehearsalFromJson(json);
}
