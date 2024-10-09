import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication.dart';

class MedicationProvider with ChangeNotifier {
  final List<Medication> _medications = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  List<Medication> get medications => _medications;

  MedicationProvider() {
    fetchMedications(); // Initialize by fetching existing medications
  }

  // Fetch medications from Firestore and listen for real-time updates
  void fetchMedications() {
    _firestore
        .collection('medications')
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

  // Add a new medication to Firestore
  Future<void> addMedication(Medication medication) async {
    try {
      await _firestore.collection('medications').add(medication.toMap());
      // Removed manual list insertion and notifyListeners()
    } catch (e) {
      print("Error adding medication: $e");
      // You can handle errors more gracefully here
    }
  }

  // Remove a medication from Firestore
  Future<void> removeMedication(Medication medication) async {
    try {
      await _firestore.collection('medications').doc(medication.id).delete();
      // Removed manual list removal and notifyListeners()
    } catch (e) {
      print("Error deleting medication: $e");
      // You can handle errors more gracefully here
    }
  }

  // Optionally, clear all medications (if needed)
  Future<void> clearMedications() async {
    try {
      WriteBatch batch = _firestore.batch();
      for (var med in _medications) {
        DocumentReference docRef =
            _firestore.collection('medications').doc(med.id);
        batch.delete(docRef);
      }
      await batch.commit();
      _medications.clear();
      notifyListeners();
    } catch (e) {
      print("Error clearing medications: $e");
      // You can handle errors more gracefully here
    }
  }
}