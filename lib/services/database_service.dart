import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add FirebaseAuth import
import '../models/blood_sugar.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Add FirebaseAuth instance

  Future<void> addBloodSugar(BloodSugar bloodSugar) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('User not logged in');
    }

    await _db.collection('users').doc(userId).collection('blood_sugar').add({
      'level': bloodSugar.level,
      'dateTime': bloodSugar.dateTime,
    });
  }

  Stream<List<BloodSugar>> getBloodSugar() {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      // Handle error: user not logged in
      return Stream.value([]);
    }

    return _db
        .collection('users')
        .doc(userId)
        .collection('blood_sugar')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BloodSugar(
          id: doc.id,
          level: doc['level'],
          dateTime: (doc['dateTime'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}
