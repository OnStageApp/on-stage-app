import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@Freezed()
class User with _$User {
  const factory User({
    required String id,
    String? email,
    String? phone,
    String? photoUrl,
    String? name,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
