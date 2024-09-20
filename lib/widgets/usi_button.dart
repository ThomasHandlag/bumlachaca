import 'package:flutter/material.dart';

class UsiButton extends StatelessWidget {
  final Function() onPressed;
  final BoxDecoration? decoration;
  final double? radius;
  final Widget? child;
  final EdgeInsets? padding;
  const UsiButton(
      {super.key,
      required this.onPressed,
      this.decoration = const BoxDecoration(),
      this.radius = 10,
      this.child = const Text("Button"),
      this.padding =
          const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20)});
  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(radius!),
        child: InkWell(
            onTap: () {
              onPressed();
            },
            child: Container(
                height: 50,
                decoration: decoration,
                child: Center(child: child))));
  }
}
