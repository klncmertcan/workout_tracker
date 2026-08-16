import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/workout_store.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName});

  final int exerciseId;
  final String exerciseName;

  
  @override
  Widget build(BuildContext context) {
    final logs = context.watch<WorkoutStore>().currentSets;

    return Scaffold(
      appBar: AppBar(title: Text('$exerciseName log')),
      body: logs.isEmpty
          ? const Center(child: Text('No sets logged yet.'))
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index){
                final set = logs[index];
                return ListTile(
                  title: Text('${set.weight} kg x ${set.reps}'),
                  subtitle: Text(set.date),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext){
                          return AlertDialog(
                            title: const Text('Delete Set'),
                            content: Text ('Delete this set (${set.weight} kg x ${set.reps})'),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<WorkoutStore>().removeSet(set.id!, exerciseId);
                                  Navigator.pop(dialogContext);
                                },
                                child: const Text('Delete'),
                                ),
                            ]
                          );
                        },
                        );
                    },
                  ),
                );
              }
            )
    );
  }
}
