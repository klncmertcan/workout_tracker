import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'log_screen.dart';
import '../state/workout_store.dart';


class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key, required this.exerciseName});

  final String exerciseName;
  
  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState(); 
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final weightController = TextEditingController();
  final repsController = TextEditingController();

  void saveSet(){
    final weight = double.tryParse(weightController.text);
    final reps = int.tryParse(repsController.text);

    if(weight == null || reps == null) return;

    context.read<WorkoutStore>().addSet(
      widget.exerciseName,
      '$weight kg x $reps',
    );

    weightController.clear();
    repsController.clear();
  }

  @override
  void dispose(){
    weightController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<WorkoutStore>();
    final sets = store.setsFor(widget.exerciseName);

    return Scaffold(
      appBar: AppBar(title: Text(widget.exerciseName)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children:[
            Text('Last 3 sets'),
            SizedBox(height: 8),
            for (var s in sets.take(3)) Text(s),
            SizedBox(height: 24),
            Text('Add new set'),
            SizedBox(height: 8),
            Row(
              children: [            
                Expanded(child: TextField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                ),),

                Expanded(child: TextField(
                  controller: repsController,
                  decoration: const InputDecoration(
                    labelText: 'Reps',
                    border:OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                ),),
              ]
            ),
            
            ElevatedButton(
              onPressed: saveSet,
              child: Text('Elevated Button - SAVE')
            ),

            TextButton(
              onPressed: (){
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => LogScreen(exerciseName: widget.exerciseName),
                  )
                );
              },
              child: Text('Text Button - LOG')
            ),
          ],
        )       
      )
    );
  }
}


