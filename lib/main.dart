import 'package:flutter/material.dart';
import 'package:vetplus/screens/welcome_screen.dart';
import 'package:vetplus/theme/colors.dart';
import 'package:vetplus/theme/typography.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VetPlus',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: textTheme,
      ),
      home: const WelcomeScreen(title: 'VetPlus'),
    );
  }
}
