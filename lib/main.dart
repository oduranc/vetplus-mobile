import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetplus/screens/welcome_screen.dart';
import 'package:vetplus/theme/colors.dart';
import 'package:vetplus/theme/shapes.dart';
import 'package:vetplus/theme/typography.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
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
        elevatedButtonTheme: elevatedButtonTheme,
      ),
      home: const WelcomeScreen(title: 'VetPlus'),
    );
  }
}
