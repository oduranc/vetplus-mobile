import 'package:flutter/material.dart';
import 'package:vetplus/theme/shapes.dart';
import 'package:vetplus/widgets/welcome_carousel.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.title});

  final String title;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  'assets/images/vetplus-logo.png',
                  height: 64,
                ),
                const WelcomeCarousel(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Iniciar sesión'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Crear cuenta'),
                      style: secondaryElevatedButton.style,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
