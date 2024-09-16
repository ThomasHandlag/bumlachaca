import 'package:flutter/material.dart';

class Slide extends StatefulWidget {
  final String quote;
  final String description;

  const Slide({super.key, required this.quote, required this.description});

  @override
  State<Slide> createState() => SlideState();
}

class SlideState extends State<Slide> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation opacityAnimation;
  late Animation translateAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInCubic));
    translateAnimation = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
              padding: const EdgeInsets.all(10),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                      offset: Offset(translateAnimation.value * 40, 0),
                      child: Opacity(
                          opacity: opacityAnimation.value,
                          child: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                widget.quote,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )))),
                  Opacity(
                      opacity: opacityAnimation.value,
                      child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(widget.description))),
                ],
              ));
        },
      );
}
