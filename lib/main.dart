import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/l10n/l10n.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/home/favorite_screen.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/screens/pets/first_add_pet_screen.dart';
import 'package:vetplus/screens/pets/my_pets_screen.dart';
import 'package:vetplus/screens/pets/pet_dashboard.dart';
import 'package:vetplus/screens/pets/pet_profile.dart';
import 'package:vetplus/screens/pets/second_add_pet_screen.dart';
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
          ),
          ChangeNotifierProvider(
            create: (_) => PetsProvider(),
          )
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _locale = 'en';

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getDeviceLocale();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getDeviceLocale();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    ScreenUtil.init(context, designSize: const Size(392.7, 826.9));

    final HttpLink httpLink = HttpLink(dotenv.env['API_LINK']!);

    initializeGraphQLClient(httpLink);

    return GraphQLProvider(
      client: globalGraphQLClient,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        locale: Locale(_locale),
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
      NavigationBarTemplate.route: (context) =>
          const NavigationBarTemplate(index: 0),
      FavoriteScreen.route: (context) => const FavoriteScreen(),
      PersonalInformationScreen.route: (context) =>
          const PersonalInformationScreen(),
      FirstAddPetScreen.route: (context) => const FirstAddPetScreen(),
      SecondAddPetScreen.route: (context) => const SecondAddPetScreen(),
      MyPetsScreen.route: (context) => const MyPetsScreen(),
      PetDashboard.route: (context) => const PetDashboard(),
      PetProfile.route: (context) => const PetProfile(),
    };
  }

  void getDeviceLocale() {
    if (Platform.localeName.startsWith('es')) {
      setState(() {
        _locale = 'es';
      });
    } else {
      setState(() {
        _locale = 'en';
      });
    }
  }
}
