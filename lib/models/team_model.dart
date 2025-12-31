import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  final String id;
  final String name;
  final String captain;
  final String colorHex; // Color code like "#FFA500"
  final int played;
  final int won;
  final int lost;
  final int points;
  final String nrr; // Net Run Rate

  TeamModel({
    required this.id,
    required this.name,
    required this.captain,
    required this.colorHex,
    required this.played,
    required this.won,
    required this.lost,
    required this.points,
    required this.nrr,
  });

  // Firestore theke data niye ashar jonno
  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TeamModel(
      id: doc.id,
      name: data['name'] ?? '',
      captain: data['captain'] ?? '',
      colorHex: data['colorHex'] ?? '#1A237E',
      played: data['played'] ?? 0,
      won: data['won'] ?? 0,
      lost: data['lost'] ?? 0,
      points: data['points'] ?? 0,
      nrr: data['nrr'] ?? '+0.00',
    );
  }

  // Firestore e data pathano jonno
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'captain': captain,
      'colorHex': colorHex,
      'played': played,
      'won': won,
      'lost': lost,
      'points': points,
      'nrr': nrr,
    };
  }
}
