import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  String id; // New field to store Firestore document ID
  final String type;
  final String amount;
  final DateTime dateTime;

  Medication({
    this.id = '', // Initialize with an empty string
    required this.type,
    required this.amount,
    required this.dateTime,
  });

  // Factory constructor to create a Medication instance from Firestore document
  factory Medication.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Medication(
      id: doc.id,
      type: data['type'] ?? '',
      amount: data['amount'] ?? '',
      dateTime: DateTime.parse(data['dateTime']),
    );
  }

  // Method to convert Medication instance to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
