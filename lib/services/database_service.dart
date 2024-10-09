import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/blood_sugar.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> addBloodSugar(BloodSugar bloodSugar) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    DocumentReference docRef = await _db.collection('blood_sugar').add(bloodSugar.toFirestore());
    return docRef.id;
  }

  Stream<List<BloodSugar>> getBloodSugar() {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      return Stream.value([]);
    }

    return _db
        .collection('blood_sugar')
        .where('userId', isEqualTo: userId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BloodSugar.fromFirestore(doc)).toList();
    });
  }
}
