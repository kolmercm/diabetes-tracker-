import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/database_service.dart';
import 'package:flutter/foundation.dart';

class FoodItemProvider extends ChangeNotifier {
  final List<FoodItem> _foodItems = [];
  final DatabaseService _dbService = DatabaseService();

  List<FoodItem> get foodItems => _foodItems;

  FoodItemProvider() {
    fetchFoodItems();
  }

  void fetchFoodItems() {
    _dbService.getFoodItems().listen((foodItems) {
      _foodItems.clear();
      _foodItems.addAll(foodItems);
      notifyListeners();
    });
  }

  Future<void> addFoodItem(FoodItem foodItem) async {
    await _dbService.addFoodItem(foodItem);
  }

  Future<void> removeFoodItem(FoodItem foodItem) async {
    await _dbService.removeFoodItem(foodItem);
  }
}
