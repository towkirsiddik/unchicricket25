class AppConstants {
  static const String appName = 'Local Cricket League';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Blizzing Cricket Updates';

  // Tournament Constants
  static const String currentTournament = 'Community Cup 2024';
  static const int totalTeams = 8;
  static const int totalMatches = 12;
  static const String tournamentPrize = '₹50,000';

  // API Endpoints (Will be used later)
  static const String baseUrl = 'https://your-api-url.com';
  static const String matchesEndpoint = '/api/matches';
  static const String playersEndpoint = '/api/players';
  static const String teamsEndpoint = '/api/teams';

  // Shared Preferences Keys
  static const String prefUserToken = 'user_token';
  static const String prefUserName = 'user_name';
  static const String prefUserEmail = 'user_email';

  // Firebase Collections
  static const String firebaseMatches = 'matches';
  static const String firebasePlayers = 'players';
  static const String firebaseTeams = 'teams';
  static const String firebaseTournaments = 'tournaments';
  static const String firebaseNews = 'news';
  static const String firebaseSponsors = 'sponsors';

  // App URLs
  static const String privacyPolicyUrl = 'https://your-privacy-policy.com';
  static const String termsUrl = 'https://your-terms.com';
  static const String contactEmail = 'support@localcricketleague.com';
  static const String websiteUrl = 'https://localcricketleague.com';
}
