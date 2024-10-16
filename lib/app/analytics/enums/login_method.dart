enum LoginMethod {
  google,
  apple,
}

extension LoginMethodX on LoginMethod {
  String get name {
    switch (this) {
      case LoginMethod.google:
        return 'google';
      case LoginMethod.apple:
        return 'apple';
    }
  }
}
