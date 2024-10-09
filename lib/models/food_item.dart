import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  String id;
  final String name;
  final String amount;
  final DateTime dateTime;

  FoodItem({
    this.id = '',
    required this.name,
    required this.amount,
    required this.dateTime,
  });

  factory FoodItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return FoodItem(
      id: doc.id,
      name: data['name'] ?? '',
      amount: data['amount'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'dateTime': dateTime,
    };
  }
}
