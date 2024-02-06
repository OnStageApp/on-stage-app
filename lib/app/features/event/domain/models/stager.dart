import 'package:freezed_annotation/freezed_annotation.dart';

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
  }) = _Stager;

  factory Stager.fromJson(Map<String, dynamic> json) => _$StagerFromJson(json);
}
