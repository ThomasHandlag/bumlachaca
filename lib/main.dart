import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:usicat/layouts/default.dart';
import 'package:usicat/layouts/splash.dart';
import 'package:platform/platform.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:usicat/screens/home.dart';
import 'package:usicat/screens/preview.dart';
import 'package:usicat/screens/signin_screen.dart';
import 'package:usicat/screens/signup_screen.dart';

const Platform platform = LocalPlatform();

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://yixrncvqpwbtjztmkenx.supabase.co',
    anonKey: '',
  );
  runApp(const MusicApp(platform: platform));
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          (platform.isAndroid || platform.isIOS)
              ? const Default()
              : const Splash(),
      routes: <RouteBase>[
        GoRoute(
          path: 'pending',
          builder: (BuildContext context, GoRouterState state) =>
              const Default(),
        ),
        GoRoute(path: 'preview', builder: (context, state) => const Preview()),
        GoRoute(
            path: 'signin', builder: (context, state) => const SignScreen()),
        GoRoute(
            path: 'signup', builder: (context, state) => const SignupScreen()),
        GoRoute(path: 'home', builder: (context, state) => const Home()),
      ],
    ),
  ],
);

class MusicApp extends StatelessWidget {
  const MusicApp({super.key, required this.platform});
  final Platform platform;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
    );
  }
}
