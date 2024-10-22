enum ErrorType {
  PERMISSION_DENIED,
}

extension ErrorTypeX on ErrorType {
  String get name {
    switch (this) {
      case ErrorType.PERMISSION_DENIED:
        return 'PERMISSION_DENIED';
    }
  }
}
