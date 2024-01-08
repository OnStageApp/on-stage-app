class API {
  static const String _API_URL_DEV = '0525-82-76-100-87.ngrok-free.app';
  static const String _API_URL_PROD = '26ec-82-76-100-87.ngrok-free.app';
  static const String _API_URL_STAGE = '26ec-82-76-100-87.ngrok-free.app';

  static const String _FLAVOR_DEV = 'development';
  static const String _FLAVOR_PROD = 'production';
  static const String _FLAVOR_STAGE = 'stage';

  static String get apiUrl {
    switch (flavor) {
      case _FLAVOR_DEV:
        return _API_URL_DEV;
      case _FLAVOR_PROD:
        return _API_URL_PROD;
      case _FLAVOR_STAGE:
        return _API_URL_STAGE;
      default:
        return _API_URL_DEV;
    }
  }

  static String get flavor {
    return _FLAVOR_DEV;
  }

  static Uri getEvents([
    DateTime? startDate,
    DateTime? endDate,
    String? search,
  ]) {
    return Uri.https(
      apiUrl,
      'events',
      {
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (search != null) 'search': search,
      },
    );
  }

  static Uri get createEvent {
    return Uri.https(apiUrl, 'events');
  }
}
