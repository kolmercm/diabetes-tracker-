import 'package:cloud_firestore/cloud_firestore.dart';

class BloodSugar {
  final String id;
  final String userId;
  final double level;
  final DateTime dateTime;

  BloodSugar({
    required this.id,
    required this.userId,
    required this.level,
    required this.dateTime,
  });

  // Add a factory method to create a BloodSugar object from Firestore data
  static BloodSugar fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BloodSugar(
      id: doc.id,
      userId: data['userId'],
      level: data['level'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }

  // Add a method to convert BloodSugar object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'level': level,
      'dateTime': Timestamp.fromDate(dateTime),
    };
  }
}
