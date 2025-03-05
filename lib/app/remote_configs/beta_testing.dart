class BetaTestingConfig {
  BetaTestingConfig({
    required this.teamIds,
    this.allowAll = false,
  });

  factory BetaTestingConfig.fromJson(Map<String, dynamic> json) {
    return BetaTestingConfig(
      teamIds: List<String>.from(json['teamIds'] as Iterable<dynamic>),
      allowAll: json['allowAll'] as bool? ?? false,
    );
  }
  final List<String> teamIds;
  final bool allowAll;

  Map<String, dynamic> toJson() {
    return {
      'teamIds': teamIds,
      'allowAll': allowAll,
    };
  }
}
