import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AlarmProvider with ChangeNotifier {
  int _requiredSteps = 10;
  late Box _box;

  int get requiredSteps => _requiredSteps;

  AlarmProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _box = await Hive.openBox('settingsBox');
    _requiredSteps = _box.get('requiredSteps', defaultValue: 10);
    notifyListeners();
  }

  void setRequiredSteps(int steps) {
    _requiredSteps = steps;
    _box.put('requiredSteps', steps);
    notifyListeners();
  }
}
