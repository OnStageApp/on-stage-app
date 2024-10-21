import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String teamId,
    required String userId,
    required Plan plan,
    required DateTime purchaseDate,
    required DateTime expirationDate,
    @Default('ACTIVE') String status,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}
