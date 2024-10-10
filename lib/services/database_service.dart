import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add FirebaseAuth import
import '../models/blood_sugar.dart';
import '../models/food_item.dart';
import '../models/exercise.dart';

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

  Future<void> addFoodItem(FoodItem foodItem) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('User not logged in');
    }

    await _db
        .collection('users')
        .doc(userId)
        .collection('food_items')
        .add(foodItem.toMap());
  }

  Stream<List<FoodItem>> getFoodItems() {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      return Stream.value([]);
    }

    return _db
        .collection('users')
        .doc(userId)
        .collection('food_items')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => FoodItem.fromFirestore(doc)).toList();
    });
  }

  Future<void> removeFoodItem(FoodItem foodItem) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('User not logged in');
    }

    await _db
        .collection('users')
        .doc(userId)
        .collection('food_items')
        .doc(foodItem.id)
        .delete();
  }

  // Add Exercise
  Future<void> addExercise(Exercise exercise) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('User not logged in');
    }

    await _db
        .collection('users')
        .doc(userId)
        .collection('exercises')
        .add(exercise.toMap());
  }

  // Get Exercises
  Stream<List<Exercise>> getExercises() {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      return Stream.value([]);
    }

    return _db
        .collection('users')
        .doc(userId)
        .collection('exercises')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Exercise.fromFirestore(doc)).toList();
    });
  }

  // Remove Exercise
  Future<void> removeExercise(Exercise exercise) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('User not logged in');
    }

    await _db
        .collection('users')
        .doc(userId)
        .collection('exercises')
        .doc(exercise.id)
        .delete();
  }

  // Helper to get DocumentReference for an exercise
  DocumentReference getExerciseDocRef(String exerciseId) {
    String userId = _auth.currentUser?.uid ?? '';
    return _db
        .collection('users')
        .doc(userId)
        .collection('exercises')
        .doc(exerciseId);
  }
}
