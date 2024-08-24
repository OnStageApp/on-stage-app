import 'package:freezed_annotation/freezed_annotation.dart';

part 'rehearsal_model.freezed.dart';
part 'rehearsal_model.g.dart';

@freezed
class RehearsalModel with _$RehearsalModel {
  const factory RehearsalModel({
    String? id,
    String? name,
    String? location,
    DateTime? dateTime,
  }) = _RehearsalModel;

  factory RehearsalModel.fromJson(Map<String, dynamic> json) =>
      _$RehearsalModelFromJson(json);
}
