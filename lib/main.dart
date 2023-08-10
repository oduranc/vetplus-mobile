import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/screens/sign/login_screen.dart';
import 'package:vetplus/screens/sign/register_screen.dart';
import 'package:vetplus/screens/sign/welcome_screen.dart';
import 'package:vetplus/theme/colors.dart';
import 'package:vetplus/theme/shapes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    ScreenUtil.init(context, designSize: const Size(392.7, 826.9));

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        elevatedButtonTheme: elevatedButtonTheme(isTablet),
        inputDecorationTheme: inputDecorationTheme(isTablet),
        appBarTheme: appBarTheme(isTablet),
        dividerColor: const Color(0xFFDCDCDD),
        navigationBarTheme: navigationBarTheme(isTablet),
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: lightColorScheme.primary),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Color(0xFFACACAD)),
          ),
        ),
      ),
      routes: {
        WelcomeScreen.route: (context) => const WelcomeScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
        LoginScreen.route: (context) => const LoginScreen(),
        NavigationBarTemplate.route: (context) => const NavigationBarTemplate(),
      },
    );
  }
}
