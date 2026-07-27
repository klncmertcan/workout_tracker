import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_screen.dart';
import '/state/workout_store.dart';

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
          title: const Text('New entry.'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Input here:'),
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

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page Title')),
      body: ListView.builder(
        itemCount: store.exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(store.exercises[index]),
            trailing: IconButton(
              onPressed: (){
                store.removeExercise(index);
              },
              icon: const Icon(Icons.delete)),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseScreen(exerciseName: store.exercises[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ) ,  //ListView
    ); //Scaffold
  }
}
