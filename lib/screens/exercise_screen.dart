import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/logged_set.dart';
import 'log_screen.dart';
import '../state/workout_store.dart';


class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName});

  final int exerciseId;
  final String exerciseName;
  
  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState(); 
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final weightController = TextEditingController();
  final repsController = TextEditingController();

  @override
  void initState(){
    super.initState();
    context.read<WorkoutStore>().loadSetsFor(widget.exerciseId);
    context.read<WorkoutStore>().loadLastWorkout(widget.exerciseId);
  }

  void saveSet(){
    final weight = double.tryParse(weightController.text);
    final reps = int.tryParse(repsController.text);

    if(weight == null || reps == null) return;

    final store = context.read<WorkoutStore>();
    final today = DateTime.now().toIso8601String().substring(0, 10);      // YYYY-MM-DD
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
  void dispose(){
    weightController.dispose();
    repsController.dispose();
    super.dispose();
  }

  void _showRenameDialog(){
    final controller = TextEditingController(text: widget.exerciseName);
    final store = context.read<WorkoutStore>();

    showDialog(
      context: context,
      builder: (dialogContext){
        return AlertDialog(
          title: const Text('Rename exercise'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Exercise name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext), 
              child: const Text('Cancel'),
              ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if(newName.isNotEmpty){
                  store.renameExercise(widget.exerciseId, newName);
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<WorkoutStore>();
    final sets = store.currentSets;
    final lastWorkout = store.lastWorkout;
    final currentName = store.exerciseById(widget.exerciseId)?.name ?? widget.exerciseName;


    return Scaffold(
      appBar: AppBar(
        title: Text(currentName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showRenameDialog,
          ),
        ],  
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children:[
            Text('Last workout'),
            SizedBox(height: 8),
            if(lastWorkout.isEmpty)
              Text('No previous workout')
            else
              for(var s in lastWorkout) Text('${s.weight} kg x ${s.reps}',),
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
                    builder: (context) => LogScreen(
                      exerciseId: widget.exerciseId,
                      exerciseName: widget.exerciseName,
                      ),
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
