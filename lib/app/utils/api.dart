class API {
  // static const String baseUrl = 'https://onstage-event-service.onrender.com/';

  static const String baseUrl = 'https://9cff-79-119-53-200.ngrok-free.app/';

  static Future<Map<String, String>> getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
    };
    return headers;
  }

  //Events
  static const String eventsByFilter = 'events?{startDate}&{endDate}&{search}';
  static const String eventById = 'events/{id}';
  static const String events = 'events';

  //Songs
  static const String getSongs = 'songs?{search}';

  static const String verifyToken = 'verifyToken';
  static const String login = 'auth/login';
}
