import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_model.freezed.dart';
part 'refresh_token_model.g.dart';

@freezed
class RefreshTokenModel with _$RefreshTokenModel {
  const factory RefreshTokenModel({
    required String refreshToken,
  }) = _RefreshTokenModel;

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenModelFromJson(json);
}
