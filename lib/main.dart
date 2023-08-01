import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/welcome_screen.dart';
import 'package:vetplus/theme/colors.dart';
import 'package:vetplus/theme/shapes.dart';
import 'package:vetplus/theme/typography.dart';

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
        textTheme: textTheme(isTablet),
        elevatedButtonTheme: elevatedButtonTheme(isTablet),
      ),
      home: const WelcomeScreen(),
    );
  }
}
