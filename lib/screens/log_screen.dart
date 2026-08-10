import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/workout_store.dart';


class LogScreen extends StatelessWidget {
  const LogScreen({super.key, required this.exerciseName});

  final String exerciseName;

  
  @override
  Widget build(BuildContext context) {
    final logs = context.watch<WorkoutStore>().setsFor(exerciseName);

    return Scaffold(
      appBar: AppBar(title: Text('$exerciseName log')),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(logs[index]),
            subtitle: Text('Date'),
          );
        }
      )
    );
  }
}
