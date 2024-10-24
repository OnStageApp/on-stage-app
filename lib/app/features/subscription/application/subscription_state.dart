import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/subscription/domain/subscription.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'subscription_state.freezed.dart';

@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    CustomerInfo? customerInfo,
    Subscription? currentSubscription,
    @Default(false) bool isLoading,
    String? errorMessage,
    bool? hasPremiumAccess,
    Plan? currentPlan,
  }) = _SubscriptionState;
}
