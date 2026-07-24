import 'package:flutter/material.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key, required this.exerciseName});

  final String exerciseName;

  final List<String> logs = const [
    'log1',
    'log2',
    'log3',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$exerciseName log')),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(logs[index]),
            subtitle: Text('Date'),
          );
        }
      )
    );
  }
}