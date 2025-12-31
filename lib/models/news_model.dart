import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final bool isHot; // Featured/Hot news
  final bool isFeatured;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.isHot,
    required this.isFeatured,
  });

  // Firestore theke data niye ashar jonno
  factory NewsModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NewsModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl:
          data['imageUrl'] ??
          'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
      date: (data['date'] as Timestamp).toDate(),
      isHot: data['isHot'] ?? false,
      isFeatured: data['isFeatured'] ?? false,
    );
  }

  // Firestore e data pathano jonno
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'date': Timestamp.fromDate(date),
      'isHot': isHot,
      'isFeatured': isFeatured,
    };
  }

  // Date ke readable format e convert
  String get formattedDate {
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }
}
