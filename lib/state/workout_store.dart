import 'package:flutter/foundation.dart';
import '../data/workout_repository.dart';
import '../models/exercise.dart';
import '../models/logged_set.dart';

class WorkoutStore extends ChangeNotifier {
  final _repo = WorkoutRepository();

  List<Exercise> _exercises = [];
  List<Exercise> get exercises => List.unmodifiable(_exercises);

  List<LoggedSet> _lastWorkout = [];
  List<LoggedSet> get lastWorkout => List.unmodifiable(_lastWorkout);

  Future<void> loadExercises() async {                    // Load from disk at the app start
    _exercises = await _repo.getExercises();
    notifyListeners();
  }

  Future<void> addExercise(String name) async {
    await _repo.addExercise(name);
    await loadExercises();
  }

  Future<void> removeExercise(int id) async {
    await _repo.deleteExercise(id);
    await loadExercises();
  }

  List<LoggedSet> _currentSets = [];                                     
  List<LoggedSet> get currentSets => List.unmodifiable(_currentSets); // Holds sets in memory temporarily

  Future<void> loadSetsFor(int exerciseId) async {                    // Load sets from memory
    _currentSets = await _repo.getSetsForExercise(exerciseId);
    notifyListeners();
  }

  Future<void> addSet(LoggedSet set) async {
    await _repo.addSet(set);
    await loadSetsFor(set.exerciseId);
    await loadLastWorkout(set.exerciseId);
  }

  Future<void> loadLastWorkout(int exerciseId) async {
    _lastWorkout = await _repo.getLastWorkout(exerciseId);
    notifyListeners();
  }

  Future<void> removeSet(int setId, int exerciseId) async {
    await _repo.deleteSet(setId);
    await loadSetsFor(exerciseId);
    await loadLastWorkout(exerciseId);
  }

  Future<void> renameExercise(int id, String newName) async {
    await _repo.updateExerciseName(id, newName);
    await loadExercises();
  }

  Exercise? exerciseById(int id){
    for(final e in _exercises){
      if(e.id == id) return e;
    }
    return null;
  }

  bool exerciseNameExists(String name){
    return _exercises.any(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
    );
  }

}
