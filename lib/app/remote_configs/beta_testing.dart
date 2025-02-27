class BetaTestingConfig {
  BetaTestingConfig({
    required this.teamIds,
  });

  factory BetaTestingConfig.fromJson(Map<String, dynamic> json) {
    final teamIdsValue = json['teamIds'];
    List<String> teamIds;

    if (teamIdsValue is String) {
      // Remove any extra whitespace and brackets.
      final trimmed = teamIdsValue.trim();
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        final inner = trimmed.substring(1, trimmed.length - 1);
        if (inner.trim().isEmpty) {
          teamIds = [];
        } else {
          teamIds = inner.split(',').map((e) => e.trim()).toList();
        }
      } else {
        teamIds = trimmed.split(',').map((e) => e.trim()).toList();
      }
    } else if (teamIdsValue is List) {
      teamIds = teamIdsValue.map((e) => e.toString()).toList();
    } else {
      teamIds = [];
    }

    return BetaTestingConfig(
      teamIds: teamIds,
    );
  }

  final List<String> teamIds;

  Map<String, dynamic> toJson() {
    return {
      'teamIds': teamIds,
    };
  }
}
