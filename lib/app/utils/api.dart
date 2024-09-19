class API {
  // static const String baseUrl = 'https://onstage-event-service.onrender.com/';

  // static const String baseUrl = 'http://192.168.150.65:9876/';
  static const String baseUrl = 'https://623c-86-125-110-196.ngrok-free.app/';

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
  static const String duplicateEvent = 'events/duplicate/{id}';
  static const String events = 'events';
  static const String rehearsals = 'rehearsals';
  static const String rehearsalById = 'rehearsals/{id}';
  static const String stagers = 'stagers';
  static const String stagersById = 'stagers/{id}';
  static const String eventItems = 'event-items';
  static const String upcomingEvent = 'events/upcoming';

  static const String artists = 'artists';

  static const String reminders = 'reminders';

  //Songs
  static const String getSongs = 'songs';
  static const String getSongsById = 'songs/{id}';
  static const String savedSongs = 'songs/favorites';
  static const String savedSongsWithUserId = 'songs/favorites/{songId}';

  static const String verifyToken = 'verifyToken';
  static const String login = 'auth/login';

  static const String users = 'users';
  static const String user = 'users/{id}';
  static const String userPhoto = 'users/photoUrl';

  static const String teams = 'teams';
  static const String teamById = 'teams/{id}';
  static const String currentTeam = 'teams/current';
  static const String setCurrentTeam = 'users/team/{teamId}';

  static const String teamMembers = 'team-members';
  static const String currentTeamMember = 'team-members/current';
  static const String uninvitedTeamMembers = 'team-members/uninvited';
}
