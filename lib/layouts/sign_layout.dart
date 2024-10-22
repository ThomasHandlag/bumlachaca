import 'package:flutter/material.dart';
import 'package:usicat/helper/clippers.dart';
import 'package:usicat/helper/painters.dart';
import 'package:usicat/widgets/sign_shape_background.dart';

class SignLayout extends StatefulWidget {
  const SignLayout({super.key, required this.child, this.showLoading = false});

  final Widget child;
  final bool? showLoading;
  @override
  State<SignLayout> createState() => _SignLayoutState();
}

class _SignLayoutState extends State<SignLayout> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SignShapeBackground(
              clipper: SignClipper(),
              child:
                  Container(color: const Color.fromARGB(255, 196, 153, 255))),
          widget.child,
          widget.showLoading!
              ? Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFD0C2FE),
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          const Image(
                            image: AssetImage('images/cat.png'),
                            width: 140,
                            height: 140,
                          ),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(0, -10 * _animation.value),
                              child: child,
                            ),
                            child: CustomPaint(
                              painter: BallPainter(
                                  position: const Offset(0, 40), radius: 20),
                              child: const SizedBox(width: 20, height: 20),
                            ),
                          ),
                        ],
                      ),
                      const Text("Meowing...",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))
                    ],
                  )))
              : const SizedBox()
        ],
      ),
    );
  }
}
