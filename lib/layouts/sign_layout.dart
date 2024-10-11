import 'package:flutter/material.dart';
import 'package:usicat/helper/clippers.dart';
import 'package:usicat/widgets/sign_shape_background.dart';

class SignLayout extends StatelessWidget {
  const SignLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SignShapeBackground(
              clipper: SignClipper(),
              child:
                  Container(color: const Color.fromARGB(255, 196, 153, 255))),
          child
        ],
      ),
    );
  }
}
