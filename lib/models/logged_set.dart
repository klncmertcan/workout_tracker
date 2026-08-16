class LoggedSet {
  final int? id;
  final double weight;
  final int reps;
  final String date;
  final int setNumber;
  final int exerciseId;

  LoggedSet({this.id, required this.weight, required this.reps,
            required this.date, required this.setNumber, required this.exerciseId});

  factory LoggedSet.fromMap(Map<String, dynamic> map){
    return LoggedSet(
      id: map['set_id'] as int?,
      weight: map['weight'] as double,
      reps: map['reps'] as int,
      date: map['date'] as String,
      setNumber: map['set_number'] as int,
      exerciseId: map['exercise_id'] as int,
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'set_id': id,
      'weight': weight,
      'reps': reps,
      'date': date,
      'set_number': setNumber,
      'exercise_id': exerciseId,
    };
    
  }

}
