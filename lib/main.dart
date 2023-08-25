import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/home/favorite_screen.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/screens/profile/personal_information_screen.dart';
import 'package:vetplus/screens/sign/login_screen.dart';
import 'package:vetplus/screens/sign/register_screen.dart';
import 'package:vetplus/screens/sign/welcome_screen.dart';
import 'package:vetplus/services/graphql_client.dart';
import 'package:vetplus/themes/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  //initializeFirebase();
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then(
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          )
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    ScreenUtil.init(context, designSize: const Size(392.7, 826.9));

    final HttpLink httpLink = HttpLink(dotenv.env['API_LINK']!);

    initializeGraphQLClient(httpLink);

    return GraphQLProvider(
      client: globalGraphQLClient,
      child: MaterialApp(
        theme: buildAppTheme(isTablet),
        routes: _buildRoutes(),
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      WelcomeScreen.route: (context) => const WelcomeScreen(),
      RegisterScreen.route: (context) => RegisterScreen(),
      LoginScreen.route: (context) => const LoginScreen(),
      NavigationBarTemplate.route: (context) => const NavigationBarTemplate(),
      FavoriteScreen.route: (context) => const FavoriteScreen(),
      PersonalInformationScreen.route: (context) =>
          const PersonalInformationScreen(),
    };
  }
}
