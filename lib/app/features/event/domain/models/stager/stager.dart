import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';

part 'stager.freezed.dart';
part 'stager.g.dart';

@Freezed()
class Stager with _$Stager {
  const factory Stager({
    required String id,
    required String firstName,
    required String lastName,
    required String picture,
    required String email,
    required String phone,
    required StagerStatusEnum status,
  }) = _Stager;

  factory Stager.fromJson(Map<String, dynamic> json) => _$StagerFromJson(json);
}
