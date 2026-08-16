class Exercise {
  final int? id;                                // id can be null at the start
  final String name;                            

  Exercise({this.id, required this.name});              // Used while creating new objects

  factory Exercise.fromMap(Map<String, dynamic> map){   // factory -> constructor 
    return Exercise(                                    // Creates an exercise object
      id: map['exercise_id'] as int?,                    // using data from the map
      name: map['exercise_name'] as String,             // Used while fetching data from the database
    );
  }

  Map<String, dynamic> toMap(){                         // Converts an object to a map
    return {
      'exercise_id': id,
      'exercise_name': name,
    };
  }
}

