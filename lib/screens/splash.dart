import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer' show log;

import 'package:musicplayer/screens/default.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SplashAnimation(
                screenSize: Offset(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height))
          ],
        ));
  }
}

class SplashAnimation extends StatefulWidget {
  const SplashAnimation({super.key, required this.screenSize});

  final Offset screenSize;

  @override
  State<StatefulWidget> createState() => SplashAnimationState();
}

class SplashAnimationState extends State<SplashAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _logoDownOffsetTween;
  late Animation _logoRotateTweenLeft;
  late Animation _offsetLogoTweenLeft;
  late Animation _textOpacityTween;
  late Animation _offsetOverlayLeft;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Default();
        }));
      }
    });
    double x = widget.screenSize.dx;
    double y = widget.screenSize.dy;
    _logoDownOffsetTween =
        Tween<Offset>(begin: Offset(0, -y / 2), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _controller, curve: const Interval(0, 0.25)));

    _logoRotateTweenLeft = Tween<double>(begin: -pi / 2, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.5)));

    _textOpacityTween = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1)));

    _offsetOverlayLeft =
        Tween<Offset>(begin: const Offset(0, 0), end: Offset(-x * 0.8, 0))
            .animate(CurvedAnimation(
                parent: _controller, curve: const Interval(0.5, 1)));

    _offsetLogoTweenLeft =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-80, 0))
            .animate(CurvedAnimation(
                parent: _controller, curve: const Interval(0.5, 1)));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(children: [
            Opacity(
                opacity: _textOpacityTween.value,
                child: Center(
                    child: Transform.translate(
                        offset: const Offset(70, 20),
                        child: Text("usicat",
                            style: GoogleFonts.getFont('Itim',
                                fontSize: 64, fontWeight: FontWeight.bold))))),
            Transform.translate(
                offset: _offsetOverlayLeft.value,
                child: Center(
                    child: Container(
                  color: Colors.white,
                  width: 400,
                  height: 200,
                ))),
            Transform.translate(
                offset: _logoDownOffsetTween.value,
                child: Transform.rotate(
                    angle: _logoRotateTweenLeft.value,
                    child: Transform.translate(
                        offset: _offsetLogoTweenLeft.value,
                        child: Stack(
                          children: [
                            Opacity(
                                opacity: _textOpacityTween.value,
                                child: Center(
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromARGB(
                                          255, 94, 24, 216),
                                    ),
                                  ),
                                )),
                            Center(
                                child: Image.asset(
                              "images/logo.png",
                              height: 100,
                              width: 100,
                            ))
                          ],
                        ))))
          ]);
        });
  }
}
