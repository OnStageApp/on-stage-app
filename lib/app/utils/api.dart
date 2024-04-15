class API {
  static const String _API_URL_DEV = 'onstage-event-service.onrender.com';
  static const String _API_URL_PROD = 'onstage-event-service.onrender.com';
  static const String _API_URL_STAGE = 'onstage-event-service.onrender.com';

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

  static Uri getEvent(String eventId) {
    return Uri.https(apiUrl, 'events/$eventId');
  }

  static Uri getSongs([
    String? search,
  ]) {
    return Uri.https(
      apiUrl,
      'songs',
      {
        if (search != null) 'search': search,
      },
    );
  }
  
  static Uri getSong(String songId){
    return Uri.https(apiUrl, 'songs/$songId');
  }

  static Uri get createEvent {
    return Uri.https(apiUrl, 'event');
  }
}
