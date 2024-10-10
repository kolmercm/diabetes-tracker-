import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String id;
  final String name;
  final String duration;
  final DateTime dateTime;

  Exercise({
    this.id = '',
    required this.name,
    required this.duration,
    required this.dateTime,
  });

  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Exercise(
      id: doc.id,
      name: data['name'] ?? '',
      duration: data['duration'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'duration': duration,
      'dateTime': dateTime,
    };
  }
}
