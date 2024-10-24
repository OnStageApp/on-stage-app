class API {
  // static const String domain = 'dev.on-stage.app';
  static const String domain = 'd26d-82-78-122-192.ngrok-free.app';
  static const String baseUrl = 'https://$domain/';
  static const String wsBaseUrl = 'wss://$domain/ws/websocket';

  // static const String baseUrl = 'http://fb72-86-127-188-157.ngrok-free.app/';

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
  static const String leadVocalsByEventItemId = 'event-items/{id}/lead-vocals';
  static const String upcomingEvent = 'events/upcoming';

  static const String artists = 'artists';

  static const String reminders = 'reminders';

  //Songs
  static const String getSongs = 'songs';
  static const String addSong = 'songs';
  static const String updateSongById = 'songs/{id}';
  static const String getSongsById = 'songs/{id}';
  static const String savedSongs = 'songs/favorites';
  static const String savedSongsWithUserId = 'songs/favorites/{songId}';

  static const String verifyToken = 'verifyToken';
  static const String login = 'auth/login';

  static const String users = 'users';
  static const String currentUser = 'users/current';
  static const String user = 'users/{id}';
  static const String userPhoto = 'users/photo';
  static const String checkPermission = 'users/check-permission';

  static const String teams = 'teams';
  static const String teamById = 'teams/{id}';
  static const String currentTeam = 'teams/current';
  static const String setCurrentTeam = 'users/team/{teamId}';

  static const String teamMembers = 'team-members';
  static const String teamMembersById = 'team-members/{id}';
  static const String currentTeamMember = 'team-members/current';
  static const String uninvitedTeamMembers = 'team-members/uninvited';
  static const String addTeamMember = 'team-members/invite';
  static const String teamMemberPhotos = 'team-members/photos';

  static const String userSettings = 'user-settings';

  static const String songConfigBySongId = 'song-config/{songId}';
  static const String songConfig = 'song-config';

  //ws
  static const String wsTopicMessage = '/user';
  static const String wsNotifications = 'notifications';

  //subscriptions
  static const String intentSecret = 'stripe/setupIntent';
  static const String currentSubscription = 'subscriptions/current';
}
