import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/subscription/domain/enum/subscription_status.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String teamId,
    required String userId,
    required String planId,
    required DateTime? purchaseDate,
    required DateTime? expiryDate,
    @Default(SubscriptionStatus.inactive) SubscriptionStatus status,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}
