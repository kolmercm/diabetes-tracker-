import 'package:flutter/material.dart';
import '../models/medication.dart';

class MedicationProvider with ChangeNotifier {
  final List<Medication> _medications = [];

  List<Medication> get medications => _medications;

  void addMedication(Medication medication) {
    _medications.add(medication);
    notifyListeners();
  }

  void clearMedications() {
    _medications.clear();
    notifyListeners();
  }

  void removeMedication(Medication medication) {
    _medications.remove(medication);
    notifyListeners();
  }
}