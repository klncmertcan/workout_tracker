import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/workout_store.dart';
import 'package:intl/intl.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName});

  final int exerciseId;
  final String exerciseName;

  String formatWeight(double w) {
    return w == w.roundToDouble() ? w.toStringAsFixed(0) : w.toString();
  }

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
                          DateFormat('EEEE, MMM d').format(DateTime.parse(set.date)),
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext){
                                return AlertDialog(
                                  title: const Text('Delete Set'),
                                  content: Text ('Delete this set (${formatWeight(set.weight)} kg x ${set.reps})'),
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
                      ),
                    ),
                  ],      
                );
              }
            )
    );
  }
}
