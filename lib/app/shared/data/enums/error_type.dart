enum ErrorType {
  PERMISSION_DENIED,
  RESOURCE_NOT_FOUND,
  TEAM_MEMBER_ALREADY_EXISTS,
  InternalServerError,
}

extension ErrorTypeX on ErrorType {
  String get name {
    switch (this) {
      case ErrorType.PERMISSION_DENIED:
        return 'PERMISSION_DENIED';
      case ErrorType.RESOURCE_NOT_FOUND:
        return 'RESOURCE_NOT_FOUND';
      case ErrorType.TEAM_MEMBER_ALREADY_EXISTS:
        return 'TEAM_MEMBER_ALREADY_EXISTS';
      case ErrorType.InternalServerError:
        return 'InternalServerError';
    }
  }

  String getDescription(String resourceName) {
    switch (this) {
      case ErrorType.PERMISSION_DENIED:
        return 'Permission denied';
      case ErrorType.RESOURCE_NOT_FOUND:
        return '$resourceName not found';
      case ErrorType.TEAM_MEMBER_ALREADY_EXISTS:
        return 'Team member already exists';
      case ErrorType.InternalServerError:
        return 'Internal server error';
    }
  }
}
