import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  // bool? data;

  // @override
  // void reassemble() {

  //   super.reassemble();
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isNewDownload().then((value) {
      if (value) {
        context.pushReplacement('/preview');
      } else {
        context.pushReplacement('/home');
      }
    });
    return Scaffold(body: Container());
  }
}
