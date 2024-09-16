import 'package:flutter/material.dart';
import 'package:musicplayer/screens/preview.dart';
import 'package:musicplayer/screens/signin_screen.dart';
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

    isNewDownload().then((value) {
      if (value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Preview();
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const SignScreen();
        }));
      }
    });
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
        body: AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Center(
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10)),
                child: Transform.scale(
                    scale: bounceAnimation.value,
                    child: Image.asset('images/logo.png',
                        width: 80, height: 90))));
      },
    ));
  }
}
