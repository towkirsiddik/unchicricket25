import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentModel {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String prize;
  final int totalTeams;
  final int totalMatches;
  final bool isActive;
  final String imageUrl;

  TournamentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.prize,
    required this.totalTeams,
    required this.totalMatches,
    required this.isActive,
    required this.imageUrl,
  });

  // Firestore theke data niye ashar jonno
  factory TournamentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TournamentModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      prize: data['prize'] ?? '₹0',
      totalTeams: data['totalTeams'] ?? 0,
      totalMatches: data['totalMatches'] ?? 0,
      isActive: data['isActive'] ?? false,
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Firestore e data pathano jonno
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'prize': prize,
      'totalTeams': totalTeams,
      'totalMatches': totalMatches,
      'isActive': isActive,
      'imageUrl': imageUrl,
    };
  }

  // Date format kora
  String get formattedStartDate {
    return '${startDate.day}/${startDate.month}/${startDate.year}';
  }

  String get formattedEndDate {
    return '${endDate.day}/${endDate.month}/${endDate.year}';
  }
}
