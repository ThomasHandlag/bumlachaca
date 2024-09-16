import 'package:flutter/material.dart';
import 'package:musicplayer/layouts/default.dart';
import 'package:musicplayer/screens/preview.dart';
import 'package:musicplayer/layouts/splash.dart';
import 'package:platform/platform.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Platform platform = const LocalPlatform();
  runApp(MusicApp(platform: platform));
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key, required this.platform});
  final Platform platform;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: (platform.isAndroid || platform.isIOS)
          ? const Default()
          : const Splash(),
    );
  }
}
