import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:usicat/layouts/custom_scaffold.dart';
import 'package:usicat/layouts/default.dart';
import 'package:usicat/layouts/splash.dart';
import 'package:platform/platform.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:usicat/screens/home.dart';
import 'package:usicat/screens/player.dart';
import 'package:usicat/screens/preview.dart';
import 'package:usicat/screens/signin_screen.dart';
import 'package:usicat/screens/signup_screen.dart';
import 'package:win32_registry/win32_registry.dart';

const Platform platform = LocalPlatform();

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

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://yixrncvqpwbtjztmkenx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpeHJuY3ZxcHdidGp6dG1rZW54Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ0OTYyNTQsImV4cCI6MjA0MDA3MjI1NH0.RzNZzoPBJbEt4u5ertugmVqlxwrcCfHVxayJ-PuqKnQ',
  );
  final platform = LocalPlatform();
  if (platform.isWindows) {
    await register('usicat');
  }
  runApp(const MusicApp());
}

final GlobalKey<NavigatorState> homeShellNavigatorKey =
    GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> rootHomeNavigatorKey =
    GlobalKey<NavigatorState>();

final ValueNotifier<RoutingConfig> routingConfig = ValueNotifier(RoutingConfig(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          (platform.isAndroid || platform.isIOS)
              ? const Default()
              : const Splash(),
    ),
    GoRoute(
      path: '/default',
      builder: (context, state) => const Default(),
    ),
    GoRoute(path: '/preview', builder: (context, state) => const Preview()),
    GoRoute(path: '/signin', builder: (context, state) => const SignScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    ShellRoute(
        navigatorKey: homeShellNavigatorKey,
        builder: (context, state, child) => CustomScaffold(child: child),
        routes: [
          GoRoute(
              path: '/home',
              builder: (context, state) => const Home(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'player',
                  builder: (context, state) => const Player(),
                )
              ])
        ]),
  ],
));

final GoRouter _router = GoRouter.routingConfig(
    routingConfig: routingConfig,
    debugLogDiagnostics: true,
    navigatorKey: rootHomeNavigatorKey);

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<StatefulWidget> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final ColorScheme colorScheme = const ColorScheme(
    primary: Color(0xFF6200EE),
    primaryVariant: Color(0xFF3700B3),
    secondary: Color(0xFF03DAC6),
    secondaryVariant: Color(0xFF018786),
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onSurface: Color(0xFF000000),
    onBackground: Color(0xFF000000),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  final TextSizeScheme textSizeScheme = TextSizeScheme.fromSeed(16.0);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MusicAppThemeData(
      textSizeScheme,
      colorScheme: colorScheme,
      child: MaterialApp.router(
        routerConfig: _router,
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
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}

class MusicAppThemeData extends InheritedWidget {
  const MusicAppThemeData(this.textSizeScheme,
      {super.key, required super.child, required this.colorScheme});

  static MusicAppThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MusicAppThemeData>();
  }

  static MusicAppThemeData of(BuildContext context) {
    final MusicAppThemeData? result = maybeOf(context);
    assert(result != null, 'No Data found in context');
    return result!;
  }

  final ColorScheme colorScheme;
  final TextSizeScheme textSizeScheme;

  @override
  bool updateShouldNotify(covariant MusicAppThemeData oldWidget) =>
      colorScheme != oldWidget.colorScheme;
}

class ColorScheme {
  const ColorScheme({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.secondaryVariant,
    required this.surface,
    required this.background,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onSurface,
    required this.onBackground,
    required this.onError,
    required this.brightness,
  });

  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color surface;
  final Color background;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onSurface;
  final Color onBackground;
  final Color onError;
  final Brightness brightness;

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ColorScheme) return false;
    return primary == other.primary &&
        primaryVariant == other.primaryVariant &&
        secondary == other.secondary &&
        secondaryVariant == other.secondaryVariant &&
        surface == other.surface &&
        background == other.background &&
        error == other.error &&
        onPrimary == other.onPrimary &&
        onSecondary == other.onSecondary &&
        onSurface == other.onSurface &&
        onBackground == other.onBackground &&
        onError == other.onError &&
        brightness == other.brightness;
  }

  @override
  int get hashCode {
    return primary.hashCode ^
        primaryVariant.hashCode ^
        secondary.hashCode ^
        secondaryVariant.hashCode ^
        surface.hashCode ^
        background.hashCode ^
        error.hashCode ^
        onPrimary.hashCode ^
        onSecondary.hashCode ^
        onSurface.hashCode ^
        onBackground.hashCode ^
        onError.hashCode ^
        brightness.hashCode;
  }
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
