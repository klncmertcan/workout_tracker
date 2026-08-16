import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import '../models/exercise.dart';
import '../models/logged_set.dart';


class WorkoutRepository {
  
  Future<Database> get _db async => DatabaseHelper.instance.database;   // Getter for database

  Future<int> addExercise(String name) async {                          // Returns exercise_id
    final db = await _db;
    return await db.insert(
      'exercises',                                                      // Table to insert
      {'exercise_name': name},                                          // What to insert
    );
  }

  Future<List<Exercise>> getExercises() async {                          // Returns a list (Each row is a map)
    final db = await _db;
    final maps = await db.query ('exercises');                          // SELECT * FROM exercises
    return maps.map((map) => Exercise.fromMap(map)).toList();           // Convert each map (row) into an object, and then to list
  }

  Future<int> addSet(LoggedSet set) async {                             // Insert new set
    final db = await _db;
    return await db.insert('logged_sets', set.toMap());
  }

  Future<List<LoggedSet>> getSetsForExercise(int exerciseId) async {
    final db = await _db;
    final maps = await db.query(
      'logged_sets',
      where: 'exercise_id = ?',                                         // Placeholder -> ?
      whereArgs: [exerciseId],
      orderBy: 'date DESC, set_id DESC',                                // Order of logged sets
    );
    return maps.map((map) => LoggedSet.fromMap(map)).toList();
  }

  Future<List<LoggedSet>> getLastWorkout (int exerciseId) async {
    final db = await _db;
    final maps = await db.rawQuery('''
      SELECT * 
      FROM logged_sets
      WHERE exercise_id = ?
        AND date = (
          SELECT MAX(date) 
          FROM logged_sets
          WHERE exercise_id = ?   
        )
      ORDER BY set_number ASC
    ''', [exerciseId, exerciseId]);

    return maps.map((map) => LoggedSet.fromMap(map)).toList();
  }

  Future<int> deleteExercise(int id) async {
    final db = await _db;
    return await db.delete(
      'exercises',
      where: 'exercise_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSet(int setId) async {
    final db = await _db;
    return await db.delete(
      'logged_sets',
      where: 'set_id = ?',
      whereArgs: [setId],
    );
  }

  Future<int> updateExerciseName(int id, String newName) async {
    final db = await _db;
    return await db.update(
      'exercises',
      {'exercise_name': newName},
      where: 'exercise_id = ?',
      whereArgs: [id],
    );
  }

}