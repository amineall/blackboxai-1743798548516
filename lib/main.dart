import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/app.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.purple.shade800,
          secondary: Colors.purple.shade600,
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
      ),
      debugShowCheckedModeBanner: false,
      home: const App(),
    );
  }
}