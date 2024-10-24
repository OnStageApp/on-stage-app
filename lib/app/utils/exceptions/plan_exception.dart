class PlanException implements Exception {
  PlanException(this.message, [this.error]);

  final String message;
  final dynamic error;

  @override
  String toString() =>
      'PlanException: $message${error != null ? ' ($error)' : ''}';
}
