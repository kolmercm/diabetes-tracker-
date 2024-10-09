import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add FirebaseAuth import

class MedicationProvider with ChangeNotifier {
  final List<Medication> _medications = [];
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
  final FirebaseAuth _auth = FirebaseAuth.instance; // Add FirebaseAuth instance

  List<Medication> get medications => _medications;

  MedicationProvider() {
    fetchMedications(); // Initialize by fetching existing medications
  }

  // Fetch medications from Firestore and listen for real-time updates
  void fetchMedications() {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      // Handle error: user not logged in
      _medications.clear();
      notifyListeners();
      return;
    }

    _firestore
        .collection('users')
        .doc(userId)
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
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      // Handle error: user not logged in
      throw Exception('User not logged in');
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('medications')
          .add(medication.toMap());
      // No need to manually update _medications or call notifyListeners()
    } catch (e) {
      // print("Error adding medication: $e");
      throw e;
    }
  }

  // Remove a medication from Firestore
  Future<void> removeMedication(Medication medication) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      // Handle error: user not logged in
      throw Exception('User not logged in');
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('medications')
          .doc(medication.id)
          .delete();
      // No need to manually update _medications or call notifyListeners()
    } catch (e) {
      // print("Error deleting medication: $e");
      throw e;
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
      // print("Error clearing medications: $e");
      // You can handle errors more gracefully here
    }
  }
}
