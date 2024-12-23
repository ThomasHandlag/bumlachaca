import 'package:audiopc/audiopc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:usicat/audio/business/blocs.dart';
import 'package:usicat/audio/data/service/local_lib.dart';
import 'package:usicat/layouts/custom_scaffold.dart';
import 'package:usicat/layouts/default.dart';
import 'package:usicat/layouts/splash.dart';
import 'package:platform/platform.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:usicat/screens/signin_screen.dart';
import 'package:usicat/screens/signup_screen.dart';
import 'package:win32_registry/win32_registry.dart';

const Platform platform = LocalPlatform();

// Register a custom protocol handler for Windows
Future<void> register(String scheme) async {
  String appPath = platform.resolvedExecutable;

  String protocolRegKey = 'Software\\Classes\\$scheme';
  RegistryValue protocolRegValue = const RegistryValue(
    'URL Protocol',
    RegistryValueType.string,
    '',
  );
  String protocolCmdRegKey = 'shell\\open\\command';
  RegistryValue protocolCmdRegValue = RegistryValue(
    '',
    RegistryValueType.string,
    '"$appPath" "%1"',
  );

  final regKey = Registry.currentUser.createKey(protocolRegKey);
  regKey.createValue(protocolRegValue);
  regKey.createKey(protocolCmdRegKey).createValue(protocolCmdRegValue);
}

Audiopc? audioPlayer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  audioPlayer = Audiopc();
  //initialize database
  await Supabase.initialize(
    url: 'https://yixrncvqpwbtjztmkenx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpeHJuY3ZxcHdidGp6dG1rZW54Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ0OTYyNTQsImV4cCI6MjA0MDA3MjI1NH0.RzNZzoPBJbEt4u5ertugmVqlxwrcCfHVxayJ-PuqKnQ',
  );
  if (platform.isWindows) {
    await register('usicat');
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  DatabaseHelper();
  final sharedPrefrences = await SharedPreferences.getInstance();
  var isDark = sharedPrefrences.getBool('isDark');
  if (isDark == null) {
    sharedPrefrences.setBool('isDark', true);
    isDark = true;
  }
  // Bloc.observer = MusicAppBlocObserver();
  runApp(BlocProvider(
      create: (context) => GlobalUIBloc(GlobalUIState(isDark: isDark)),
      child: const MusicApp()));
}

final GlobalKey<NavigatorState> rootHomeNavigatorKey =
    GlobalKey<NavigatorState>();

final ValueNotifier<RoutingConfig> routingConfig = ValueNotifier(RoutingConfig(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const Splash(),
    ),
    GoRoute(
      path: '/default',
      builder: (context, state) => const Default(),
    ),
    GoRoute(path: '/signin', builder: (context, state) => const SignScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) => CustomScaffold(player: audioPlayer!),
    )
  ],
));

final GoRouter _router = GoRouter.routingConfig(
    routingConfig: routingConfig,
    debugLogDiagnostics: false,
    navigatorKey: rootHomeNavigatorKey);

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<StatefulWidget> createState() => _MusicAppState();
}



class _MusicAppState extends State<MusicApp> {
  final ColorScheme colorScheme = const ColorScheme(
    primary: Color(0xFF6200EE),
    secondary: Color(0xFF03DAC6),
    surface: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onSurface: Color(0xFF000000),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  final ColorScheme darkTheme = const ColorScheme(
    primary: Color(0xFFBB86FC),
    secondary: Color(0xFF03DAC6),
    surface: Color(0xFF121212),
    error: Color(0xFFCF6679),
    onPrimary: Color(0xFF000000),
    onSecondary: Color(0xFF000066),
    onSurface: Color(0xFFFFFFFF),
    onError: Color(0xFF000000),
    brightness: Brightness.dark,
  );

  final TextSizeScheme textSizeScheme = TextSizeScheme.fromSeed(16.0);
  bool isDark = true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MusicAppThemeData(
      textSizeScheme,
      colorScheme: colorScheme,
      dartTheme: darkTheme,
      child: BlocListener<GlobalUIBloc, GlobalUIState>(listener: (context, state) {
        setState(() {
          isDark = state.isDark!;
        });
      }, child: MaterialApp.router(
        routerConfig: _router,
        darkTheme: ThemeData.from(colorScheme: darkTheme),
        theme: ThemeData.from(colorScheme: colorScheme),
        themeMode: isDark
            ? ThemeMode.dark
            : ThemeMode.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('US'),
          Locale('vi'),
        ],
        title: 'Musicat',
      ),),
    );
  }
}

class MusicAppThemeData extends InheritedWidget {
  const MusicAppThemeData(this.textSizeScheme,
      {super.key,
      required super.child,
      required this.colorScheme,
      required this.dartTheme});

  static MusicAppThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MusicAppThemeData>();
  }

  static MusicAppThemeData of(BuildContext context) {
    final MusicAppThemeData? result = maybeOf(context);
    assert(result != null, 'No Data found in context');
    return result!;
  }

  final ColorScheme colorScheme;
  final ColorScheme dartTheme;
  final TextSizeScheme textSizeScheme;

  @override
  bool updateShouldNotify(covariant MusicAppThemeData oldWidget) =>
      colorScheme != oldWidget.colorScheme;
}

// define a text size scheme
class TextSizeScheme {
  final double displayLarge;
  final double displayMedium;
  final double displaySmall;
  final double headlineLarge;
  final double headlineMedium;
  final double headlineSmall;
  final double titleLarge;
  final double titleMedium;
  final double titleSmall;
  final double labelLarge;
  final double labelMedium;
  final double labelSmall;
  final double bodyLarge;
  final double bodyMedium;
  final double bodySmall;

  // Constructor with required text sizes
  TextSizeScheme({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
  });

  // Factory method to generate sizes based on a seed size
  factory TextSizeScheme.fromSeed(double seed) {
    return TextSizeScheme(
      displayLarge: seed * 3.0,
      displayMedium: seed * 2.5,
      displaySmall: seed * 2.0,
      headlineLarge: seed * 1.8,
      headlineMedium: seed * 1.6,
      headlineSmall: seed * 1.4,
      titleLarge: seed * 1.3,
      titleMedium: seed * 1.2,
      titleSmall: seed * 1.1,
      labelLarge: seed * 1.0,
      labelMedium: seed * 0.9,
      labelSmall: seed * 0.8,
      bodyLarge: seed * 1.0,
      bodyMedium: seed * 0.85,
      bodySmall: seed * 0.75,
    );
  }
}

class MusicAppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint(event.toString());
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint(transition.toString());
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint(change.toString());
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint(error.toString());
  }
}
