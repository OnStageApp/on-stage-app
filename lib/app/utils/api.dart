class API {
  // static const String baseUrl = 'https://onstage-event-service.onrender.com/';

  static const String baseUrl = 'https://localhost:9000/';

  static Future<Map<String, String>> getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
    };
    return headers;
  }

  //Events
  static const String getEvents = 'events?{startDate}&{endDate}&{search}';
  static const String getEventById = 'events/{eventId}';
  static const String createEvent = 'events';

  //Songs
  static const String getSongs = 'songs?{search}';

  static const String verifyToken = 'verifyToken';
  static const String login = 'auth/login';
}
