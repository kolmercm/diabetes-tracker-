import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blood_sugar.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addBloodSugar(BloodSugar bloodSugar) async {
    await _db.collection('blood_sugar').add({
      'level': bloodSugar.level,
      'dateTime': bloodSugar.dateTime,
    });
  }

  Stream<List<BloodSugar>> getBloodSugar() {
    return _db.collection('blood_sugar').snapshots().map((snapshot) {
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
