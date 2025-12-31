import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerModel {
  final String id;
  final String name;
  final String role; // Batsman, Bowler, All-Rounder
  final String team;
  final String? runs;
  final String? wickets;
  final String imageUrl;
  final int rank;
  final int matches;

  PlayerModel({
    required this.id,
    required this.name,
    required this.role,
    required this.team,
    this.runs,
    this.wickets,
    required this.imageUrl,
    required this.rank,
    required this.matches,
  });

  // Firestore theke data niye ashar jonno
  factory PlayerModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PlayerModel(
      id: doc.id,
      name: data['name'] ?? '',
      role: data['role'] ?? 'Batsman',
      team: data['team'] ?? '',
      runs: data['runs']?.toString(),
      wickets: data['wickets']?.toString(),
      imageUrl:
          data['imageUrl'] ?? 'https://randomuser.me/api/portraits/men/32.jpg',
      rank: data['rank'] ?? 0,
      matches: data['matches'] ?? 0,
    );
  }

  // Firestore e data pathano jonno
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'role': role,
      'team': team,
      'runs': runs,
      'wickets': wickets,
      'imageUrl': imageUrl,
      'rank': rank,
      'matches': matches,
    };
  }
}
