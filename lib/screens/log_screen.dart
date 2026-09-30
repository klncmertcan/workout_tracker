import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/workout_store.dart';
import '../utils/format.dart';
import '../widgets/dialogs.dart';

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
                final isNewDate = index == 0 || logs[index - 1].date != set.date;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(isNewDate) ...[
                      const Divider(thickness: 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical:4),
                        child: Text(
                          formatWorkoutDate(set.date),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        title: Text('${formatWeight(set.weight)} kg x ${set.reps}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final store = context.read<WorkoutStore>();
                            final confirmed = await showConfirmDialog(
                              context,
                              title: 'Delete set',
                              message: 'Delete this set (${formatWeight(set.weight)} kg x ${set.reps})?',
                            );
                            if (confirmed) store.removeSet(set.id!, exerciseId);
                          }
                        ),
                      ),
                    ),
                  ],      
                );
              }
            )
    );
  }
}
