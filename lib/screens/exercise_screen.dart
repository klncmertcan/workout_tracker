import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/logged_set.dart';
import 'log_screen.dart';
import '../state/workout_store.dart';
import '../utils/format.dart';
import '../widgets/dialogs.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  final int exerciseId;
  final String exerciseName;

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final bottomButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 20),
  );

  @override
  void initState() {
    super.initState();
    context.read<WorkoutStore>().loadSetsFor(widget.exerciseId);
    context.read<WorkoutStore>().loadLastWorkout(widget.exerciseId);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void saveSet() {
    final weightText = weightController.text.trim().replaceAll(',', '.');
    final weight = double.tryParse(weightText);
    final reps = int.tryParse(repsController.text.trim());

    if (weight == null || reps == null) {
      _showError('Enter both weight and reps');
      return;
    }

    if (weight <= 0 || reps <= 0) {
      _showError('Weight and reps must be greater than zero');
      return;
    }

    if (weight >= 1000 || reps >= 1000) {
      _showError('Value too large');
      return;
    }

    final store = context.read<WorkoutStore>();
    final today = todayAsDbDate();
    final setNumber = store.currentSets.length + 1;

    final newSet = LoggedSet(
      exerciseId: widget.exerciseId,
      weight: weight,
      reps: reps,
      setNumber: setNumber,
      date: today,
    );

    store.addSet(newSet);

    weightController.clear();
    repsController.clear();
  }

  @override
  void dispose() {
    weightController.dispose();
    repsController.dispose();
    super.dispose();
  }

  Future<void> _renameExercise() async {
    final store = context.read<WorkoutStore>();
    final currentName =
        store.exerciseById(widget.exerciseId)?.name ?? widget.exerciseName;

    final newName = await showTextInputDialog(
      context,
      title: 'Rename exercise',
      label: 'Exercise name',
      confirmLabel: 'Save',
      initialValue: currentName,
      validator: (value) =>
          value.toLowerCase() != currentName.toLowerCase() &&
              store.exerciseNameExists(value)
          ? 'An exercise with this name already exists'
          : null,
    );
    if (newName != null) store.renameExercise(widget.exerciseId, newName);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<WorkoutStore>();
    final lastWorkout = store.lastWorkout;
    final currentName =
        store.exerciseById(widget.exerciseId)?.name ?? widget.exerciseName;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentName),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _renameExercise),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Last Workout',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      if (lastWorkout.isEmpty)
                        Text(
                          'No Previous Workout',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      else
                        for (var s in lastWorkout)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              '${formatWeight(s.weight)} kg x ${s.reps} reps',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller: repsController,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogScreen(
                            exerciseId: widget.exerciseId,
                            exerciseName: currentName,
                          ),
                        ),
                      );
                    },
                    child: const Text('LOG', style: TextStyle(fontSize: 18)),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: saveSet,
                    child: const Text('SAVE', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
