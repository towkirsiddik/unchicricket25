import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final String team1;
  final String team2;
  final String score1;
  final String score2;
  final String over1;
  final String over2;
  final bool isLive;
  final String status;
  final DateTime matchDate;
  final String time;
  final String venue;
  final String matchType; // T20, ODI etc

  MatchModel({
    required this.id,
    required this.team1,
    required this.team2,
    required this.score1,
    required this.score2,
    required this.over1,
    required this.over2,
    required this.isLive,
    required this.status,
    required this.matchDate,
    required this.time,
    required this.venue,
    required this.matchType,
  });

  // Firestore theke data niye ashar jonno
  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MatchModel(
      id: doc.id,
      team1: data['team1'] ?? '',
      team2: data['team2'] ?? '',
      score1: data['score1'] ?? '0/0',
      score2: data['score2'] ?? '0/0',
      over1: data['over1'] ?? '0.0',
      over2: data['over2'] ?? '0.0',
      isLive: data['isLive'] ?? false,
      status: data['status'] ?? '',
      matchDate: (data['matchDate'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      venue: data['venue'] ?? '',
      matchType: data['matchType'] ?? 'T20',
    );
  }

  // Firestore e data pathano jonno
  Map<String, dynamic> toFirestore() {
    return {
      'team1': team1,
      'team2': team2,
      'score1': score1,
      'score2': score2,
      'over1': over1,
      'over2': over2,
      'isLive': isLive,
      'status': status,
      'matchDate': Timestamp.fromDate(matchDate),
      'time': time,
      'venue': venue,
      'matchType': matchType,
    };
  }
}
