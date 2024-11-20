import 'package:flutter/material.dart';
import 'package:usicat/helper/clippers.dart';
import 'package:usicat/widgets/loading.dart';
import 'package:usicat/widgets/sign_shape_background.dart';

class SignLayout extends StatefulWidget {
  const SignLayout({super.key, required this.child, this.showLoading = false});

  final Widget child;
  final bool? showLoading;
  @override
  State<SignLayout> createState() => _SignLayoutState();
}

class _SignLayoutState extends State<SignLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SignShapeBackground(
              clipper: SignClipper(),
              child:
                  Container(color: const Color.fromARGB(255, 196, 153, 255))),
          widget.child,
          widget.showLoading! ? const Loading() : const SizedBox()
        ],
      ),
    );
  }
}
