import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'state/workout_store.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WorkoutStore()..loadExercises(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overload',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        colorScheme: ColorScheme.dark(
          primary: const Color.fromARGB(255, 244, 198, 49),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
