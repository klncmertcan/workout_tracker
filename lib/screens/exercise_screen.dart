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

  String formatWeight(double w){
    return w == w.roundToDouble()
      ? w.toStringAsFixed(0)
      : w.toString();
  }

  void _showError(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void saveSet(){
    final weightText = weightController.text.trim().replaceAll(',', '.');
    final weight = double.tryParse(weightText);
    final reps = int.tryParse(repsController.text.trim());

    if(weight == null || reps == null){
      _showError('Enter both weight and reps');
      return;
    }

    if(weight <= 0 || reps <= 0){
      _showError('Weight and reps must be greater than zero');
      return; 
    }

    if(weight >= 1000 || reps >= 1000){
      _showError('Value too large');
      return;
    }

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
          title: const Text('Rename Exercise'),
          content: TextField(
            maxLength: 50,
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
                if(newName.toLowerCase() != widget.exerciseName.toLowerCase() && 
                  store.exerciseNameExists(newName)){
                    _showError('Exercsie already exists');
                    return;
                  }
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
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Last Workout',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    if(lastWorkout.isEmpty)
                      Text(
                        'No Previous Workout',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    else
                      for(var s in lastWorkout)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${formatWeight(s.weight)} kg x ${s.reps} reps',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                  ]
                ),
              ),
            ),
            
            Row(
              children: [            
                Expanded(child: TextField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                
                const SizedBox(width: 12),

                Expanded(child: TextField(
                  controller: repsController,
                  decoration: const InputDecoration(
                    labelText: 'Reps',
                    border:OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),),
              ]
            ),

            const SizedBox(height: 12),   
            
            Row(
              children:[
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
                    child: const Text(
                      'LOG',
                      style: TextStyle(fontSize: 18),                      
                      ),
                  ),
                ),
                
                const SizedBox(width:12),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: saveSet,
                    child: const Text(
                      'SAVE',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height:50),

          ],
        )       
      )
    );
  }
}
