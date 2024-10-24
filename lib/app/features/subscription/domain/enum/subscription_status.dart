enum SubscriptionStatus {
  active,
  inactive,
  expired,
  canceled,
}

extension SubscriptionStatusX on SubscriptionStatus {
  String toJson() => name.toUpperCase();

  static SubscriptionStatus fromJson(String value) {
    switch (value.toUpperCase()) {
      case 'active':
        return SubscriptionStatus.active;
      case 'inactive':
        return SubscriptionStatus.inactive;
      case 'expired':
        return SubscriptionStatus.expired;
      case 'canceled':
        return SubscriptionStatus.canceled;
      default:
        throw ArgumentError('Invalid subscription status: $value');
    }
  }
}
