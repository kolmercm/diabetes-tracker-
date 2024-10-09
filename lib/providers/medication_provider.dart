import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicationProvider with ChangeNotifier {
  final List<Medication> _medications = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Medication> get medications => _medications;

  MedicationProvider() {
    fetchMedications();
  }

  void fetchMedications() {
    final user = _auth.currentUser;
    if (user != null) {
      _firestore
          .collection('medications')
          .where('userId', isEqualTo: user.uid)
          .orderBy('dateTime', descending: true)
          .snapshots()
          .listen((snapshot) {
        _medications.clear();
        for (var doc in snapshot.docs) {
          _medications.add(Medication.fromFirestore(doc));
        }
        notifyListeners();
      });
    }
  }

  Future<void> addMedication(Medication medication) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('medications').add(medication.toMap());
      } catch (e) {
        print("Error adding medication: $e");
      }
    }
  }

  Future<void> removeMedication(Medication medication) async {
    try {
      await _firestore.collection('medications').doc(medication.id).delete();
    } catch (e) {
      print("Error deleting medication: $e");
    }
  }

  Future<void> clearMedications() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        var snapshot = await _firestore
            .collection('medications')
            .where('userId', isEqualTo: user.uid)
            .get();
        
        WriteBatch batch = _firestore.batch();
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        
        _medications.clear();
        notifyListeners();
      } catch (e) {
        print("Error clearing medications: $e");
      }
    }
  }
}