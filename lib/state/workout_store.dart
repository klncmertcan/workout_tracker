import 'package:flutter/foundation.dart';

class WorkoutStore extends ChangeNotifier {
  final List<String> _exercises = [
    'Entry 1',
    'Entry 2', 
    'Entry 3',
  ];

  List<String> get exercises => List.unmodifiable(_exercises);

  void addExercise(String name) {
    _exercises.add(name);
    notifyListeners();
  }

  void removeExercise(int index) {
    _exercises.removeAt(index);
    notifyListeners();
  }

  final Map<String, List<String>> _setsByExercise = {};

  List<String> setsFor(String exercise){
    return List.unmodifiable(_setsByExercise[exercise] ?? []);
  }

  void addSet(String exercise, String set){
    _setsByExercise.putIfAbsent(exercise, () => []);
    _setsByExercise[exercise]!.insert(0, set);
    notifyListeners();
  }
}