import 'package:flutter/material.dart';
import 'exercise_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> exercises = const [
    'number1',
    'number2',
    'number3',
  ];

  @override
    Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page Title')),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(exercises[index]),
            trailing: const Icon(Icons.chevron_right),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseScreen(exerciseName: exercises[index]),
                ),
              );
            },
          );
        },
  
     )  //ListView
    ); //Scaffold
  }
}
