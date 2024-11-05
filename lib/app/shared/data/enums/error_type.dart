enum ErrorType {
  PERMISSION_DENIED,
  RESOURCE_NOT_FOUND,
}

extension ErrorTypeX on ErrorType {
  String get name {
    switch (this) {
      case ErrorType.PERMISSION_DENIED:
        return 'PERMISSION_DENIED';
      case ErrorType.RESOURCE_NOT_FOUND:
        return 'RESOURCE_NOT_FOUND';
    }
  }

  String getDescription(String resourceName) {
    switch (this) {
      case ErrorType.PERMISSION_DENIED:
        return 'Permission denied';
      case ErrorType.RESOURCE_NOT_FOUND:
        return '$resourceName not found';
    }
  }
}
