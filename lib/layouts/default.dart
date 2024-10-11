import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:usicat/screens/preview.dart';
import 'package:usicat/screens/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Default extends StatefulWidget {
  const Default({super.key});

  @override
  State<StatefulWidget> createState() => DefaultState();
}

class DefaultState extends State<Default> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation bounceAnimation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    bounceAnimation = Tween(begin: 0.9, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.bounceOut));
    controller.repeat();
  }

  Future<bool> isNewDownload() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isNewDownload') ?? true;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<bool>(
            future: isNewDownload(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  context.go('preview');
                } else {
                  context.go('signin');
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
