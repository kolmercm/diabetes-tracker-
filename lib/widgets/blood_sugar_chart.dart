import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import '../models/blood_sugar.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Add this line

  Future<void> addBloodSugar(BloodSugar bloodSugar) async {
    // Add this comment: Get the current user's ID
    String userId = _auth.currentUser?.uid ?? '';
    
    await _db.collection('users').doc(userId).collection('blood_sugar').add({
      'level': bloodSugar.level,
      'dateTime': bloodSugar.dateTime,
    });
  }

  Stream<List<BloodSugar>> getBloodSugar() {
    // Add this comment: Get the current user's ID
    String userId = _auth.currentUser?.uid ?? '';
    
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
