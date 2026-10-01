import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_screen.dart';
import '../state/workout_store.dart';
import '../widgets/dialogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _addExercise() async {
    final store = context.read<WorkoutStore>();
    final name = await showTextInputDialog(
      context,
      title: 'New exercise',
      label: 'Exercise name',
      confirmLabel: 'Add',
      validator: (value) => store.exerciseNameExists(value)
          ? 'An exercise with this name already exists'
          : null,
    );
    if (name != null) store.addExercise(name);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<WorkoutStore>();
    final exercises = store.exercises;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OVERLOAD'),
        titleTextStyle: TextStyle(letterSpacing: 7, fontSize: 20),
      ),
      body: store.exercises.isEmpty
          ? const Center(child: Text('No exercises yet. Tap + and add one.'))
          : ListView.builder(
              itemCount: store.exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final confirmed = await showConfirmDialog(
                          context,
                          title: 'Delete exercise',
                          message:
                              'Delete "${exercise.name}" and all its logged sets? This cannot be undone.',
                        );
                        if (confirmed) store.removeExercise(exercise.id!);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseScreen(
                            exerciseId: exercise.id!,
                            exerciseName: exercise.name,
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }
}
