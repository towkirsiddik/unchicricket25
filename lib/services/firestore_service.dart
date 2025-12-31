import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unchi_cricket/models/match_model.dart';
import 'package:unchi_cricket/models/player_model.dart';
import 'package:unchi_cricket/models/team_model.dart';
import 'package:unchi_cricket/models/news_model.dart';
import 'package:unchi_cricket/models/tournament_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==================== MATCHES ====================

  // Live matches get kora
  Stream<List<MatchModel>> getLiveMatches() {
    return _db
        .collection('matches')
        .where('isLive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MatchModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Upcoming matches get kora
  Stream<List<MatchModel>> getUpcomingMatches() {
    return _db
        .collection('matches')
        .where('isLive', isEqualTo: false)
        .orderBy('matchDate')
        .limit(5)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MatchModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Single match details
  Stream<MatchModel> getMatchById(String matchId) {
    return _db
        .collection('matches')
        .doc(matchId)
        .snapshots()
        .map((doc) => MatchModel.fromFirestore(doc));
  }

  // ==================== PLAYERS ====================

  // Top players get kora (ranking according to)
  Stream<List<PlayerModel>> getTopPlayers() {
    return _db
        .collection('players')
        .orderBy('rank')
        .limit(10)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PlayerModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Single player details
  Stream<PlayerModel> getPlayerById(String playerId) {
    return _db
        .collection('players')
        .doc(playerId)
        .snapshots()
        .map((doc) => PlayerModel.fromFirestore(doc));
  }

  // ==================== TEAMS ====================

  // All teams get kora
  Stream<List<TeamModel>> getAllTeams() {
    return _db
        .collection('teams')
        .orderBy('points', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TeamModel.fromFirestore(doc)).toList(),
        );
  }

  // Single team details
  Stream<TeamModel> getTeamById(String teamId) {
    return _db
        .collection('teams')
        .doc(teamId)
        .snapshots()
        .map((doc) => TeamModel.fromFirestore(doc));
  }

  // ==================== NEWS ====================

  // All news get kora (latest first)
  Stream<List<NewsModel>> getAllNews() {
    return _db
        .collection('news')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => NewsModel.fromFirestore(doc)).toList(),
        );
  }

  // Featured news
  Stream<NewsModel?> getFeaturedNews() {
    return _db
        .collection('news')
        .where('isFeatured', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return NewsModel.fromFirestore(snapshot.docs.first);
        });
  }

  // ==================== HELPER METHODS ====================

  // Match add kora (Admin panel er jonno - future use)
  Future<void> addMatch(MatchModel match) async {
    await _db.collection('matches').add(match.toFirestore());
  }
  // ==================== TOURNAMENTS ====================

  // Active tournament get kora
  Stream<TournamentModel?> getActiveTournament() {
    return _db
        .collection('tournaments')
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return TournamentModel.fromFirestore(snapshot.docs.first);
        });
  }

  // Tournament add kora
  Future<void> addTournament(TournamentModel tournament) async {
    await _db.collection('tournaments').add(tournament.toFirestore());
  }

  // Match update kora
  Future<void> updateMatch(String matchId, Map<String, dynamic> data) async {
    await _db.collection('matches').doc(matchId).update(data);
  }

  // Player add kora
  Future<void> addPlayer(PlayerModel player) async {
    await _db.collection('players').add(player.toFirestore());
  }

  // Team add kora
  Future<void> addTeam(TeamModel team) async {
    await _db.collection('teams').add(team.toFirestore());
  }

  // News add kora
  Future<void> addNews(NewsModel news) async {
    await _db.collection('news').add(news.toFirestore());
  }
}
