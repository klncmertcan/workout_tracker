import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_screen.dart';
import '/state/workout_store.dart';
import '../models/exercise.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _showAddDialog(){
    final controller = TextEditingController();
    final store = context.read<WorkoutStore>(); 

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Exercise'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Exercise Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: (){
                final name = controller.text.trim();
                if(name.isNotEmpty){
                  store.addExercise(name);
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],

        );
      }
    );
  }
  
  @override
    Widget build(BuildContext context) {
      final store = context.watch<WorkoutStore>();
      final exercises = store.exercises;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OVERLOAD'),
        titleTextStyle: TextStyle(
          letterSpacing: 7,
          fontSize: 20,
          ),
        ),
      body: store.exercises.isEmpty
          ? const Center(child: Text('No exercises yet. Tap + and add one.'))
          : ListView.builder(
              itemCount: store.exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical:8),
                  child: ListTile(
                    title: Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    trailing: IconButton(
                      onPressed: () => _confirmDelete(exercise),
                      icon: const Icon(Icons.delete)),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseScreen(
                            exerciseId: exercise.id!,
                            exerciseName: exercise.name),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ) ,  //ListView
    ); //Scaffold
  }

  void _confirmDelete(Exercise exercise){
    final store = context.read<WorkoutStore>();

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Delete exercise'),
          content: Text(
            'Delete "${exercise.name}" and all its logged sets?'
            'This cannot be undone.',
          ),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                store.removeExercise(exercise.id!);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

}
