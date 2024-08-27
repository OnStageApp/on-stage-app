class API {
  // static const String baseUrl = 'https://onstage-event-service.onrender.com/';

  static const String baseUrl = 'https://c96c-86-125-110-196.ngrok-free.app/';

  // static const String baseUrl = 'http://localhost:9000/';

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
  static const String rehearsals = 'rehearsals';
  static const String rehearsalById = 'rehearsals/{id}';
  static const String stagers = 'stagers';
  static const String eventItems = 'event-items';

  //Songs
  static const String getSongs = 'songs?{search}';

  static const String verifyToken = 'verifyToken';
  static const String login = 'auth/login';

  static const String users = 'users';
  static const String uninvitedUsers = 'users/uninvited';
}
