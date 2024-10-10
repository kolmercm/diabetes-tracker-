import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise.dart';
import '../services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add FirebaseAuth import

class ExerciseProvider with ChangeNotifier {
  final List<Exercise> _exercises = [];
  final DatabaseService _dbService = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Add FirebaseAuth instance

  List<Exercise> get exercises => _exercises;

  ExerciseProvider() {
    fetchExercises(); // Initialize by fetching existing exercises
  }

  // Fetch exercises from Firestore and listen for real-time updates
  void fetchExercises() {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      // Handle error: user not logged in
      _exercises.clear();
      notifyListeners();
      return;
    }

    _dbService.getExercises().listen((exercises) {
      _exercises.clear();
      _exercises.addAll(exercises);
      notifyListeners();
    });
  }

  // Add a new exercise to Firestore
  Future<void> addExercise(Exercise exercise) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      // Handle error: user not logged in
      throw Exception('User not logged in');
    }

    try {
      await _dbService.addExercise(exercise);
      // No need to manually update _exercises or call notifyListeners()
    } catch (e) {
      throw e;
    }
  }

  // Remove an exercise from Firestore
  Future<void> removeExercise(Exercise exercise) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      // Handle error: user not logged in
      throw Exception('User not logged in');
    }

    try {
      await _dbService.removeExercise(exercise);
      // No need to manually update _exercises or call notifyListeners()
    } catch (e) {
      throw e;
    }
  }

  // Optionally, clear all exercises (if needed)
  Future<void> clearExercises() async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var exercise in _exercises) {
        DocumentReference docRef = _dbService.getExerciseDocRef(exercise.id);
        batch.delete(docRef);
      }
      await batch.commit();
      _exercises.clear();
      notifyListeners();
    } catch (e) {
      // Handle errors if necessary
    }
  }
}
