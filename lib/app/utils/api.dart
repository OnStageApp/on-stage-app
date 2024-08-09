class API {
  static const String _API_URL_DEV = 'onstage-event-service.onrender.com';
  static const String _API_URL_PROD = 'onstage-event-service.onrender.com';
  static const String _API_URL_STAGE = 'onstage-event-service.onrender.com';

  static const String _FLAVOR_DEV = 'development';
  static const String _FLAVOR_PROD = 'production';
  static const String _FLAVOR_STAGE = 'stage';

  static const String baseUrl = 'https://onstage-event-service.onrender.com/';

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

  //Events
  static const String getEvents = 'events?{startDate}&{endDate}&{search}';
  static const String getEventById = 'events/{eventId}';
  static const String createEvent = 'events';

  //Songs
  static const String getSongs = 'songs?{search}';

  static const String verifyToken = 'verifyToken';
}
