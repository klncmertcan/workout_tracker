// Opens the database and creates the tables

import 'package:sqflite/sqflite.dart';    // Library to use SQlite in flutter
import 'package:path/path.dart';          // Library to combine file paths (eliminates iOS / Android differences)

class DatabaseHelper {
  // SINGLETON PATTERN: Only one instance for DatabaseHelper class

  static final DatabaseHelper instance = DatabaseHelper._internal();  // Assigns single object to instance
  DatabaseHelper._internal();                                         // Private constructor

  static Database? _database;                                         // Private database (may be null)

  Future<Database> get database async {                               // Getter function for database
    
    if(_database != null) return _database!;                          // Don't open if it is already opened
    
    _database = await _initDatabase();                                // Wait until it opens
    return _database!;                                                
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();                          // Find database path
    final path = join(dbPath, 'workout.db');                          // Folder path + file name

    return await openDatabase(
      path,                                                           // File path
      version: 1,                                                     // Version number
      onCreate: _onCreate,                                            // Creation (not calling the function yet)
      onConfigure: _onConfigure,                                      // Connect foreign key on every start
    );
  }

  Future<void> _onConfigure(Database db) async {                      // To activate DELETE ON CASCADE
    await db.execute('PRAGMA foreign_keys = ON');                     // "db.execute" for non returning queries
  }                                                                   // "PRAGMA" for database options

  Future<void> _onCreate(Database db, int version) async {            // Only works for table creation

    await db.execute('''                        
      CREATE TABLE exercises (
        exercise_id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE logged_sets (
        set_id INTEGER PRIMARY KEY AUTOINCREMENT,
        weight REAL NOT NULL,
        reps INTEGER NOT NULL,
        date TEXT NOT NULL,
        set_number INTEGER NOT NULL, 
        exercise_id INTEGER NOT NULL,
        FOREIGN KEY (exercise_id) REFERENCES exercises (exercise_id) ON DELETE CASCADE
      )
    ''');

  }

}


