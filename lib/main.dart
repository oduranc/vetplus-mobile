import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/app_routes.dart';
import 'package:vetplus/l10n/l10n.dart';
import 'package:vetplus/providers/favorites_provider.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/services/graphql_client.dart';
import 'package:vetplus/themes/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PetsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider())
      ],
      child: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
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

  @override
  Widget build(BuildContext context) {
    // Initialize GraphQL client and other configurations
    initializeApp(context);

    return GraphQLProvider(
      client: globalGraphQLClient,
      child: MaterialApp(
        builder: (context, widget) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(
              textScaleFactor: data.textScaleFactor.clamp(0.85, 1),
            ),
            child: widget!,
          );
        },
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        theme: buildAppTheme(Responsive.isTablet(context)),
        locale: Locale(_locale),
        routes: getAppRoutes(),
      ),
    );
  }
}

void initializeApp(BuildContext context) {
  // Initialize ScreenUtil
  ScreenUtil.init(context, designSize: const Size(392.7, 826.9));

  final HttpLink httpLink = HttpLink(dotenv.env['API_LINK']!);
  initializeGraphQLClient(httpLink);
}
