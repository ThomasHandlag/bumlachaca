import 'package:flutter/material.dart';

class PulseContainer extends StatefulWidget {
  const PulseContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.constraints,
  });
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;

  @override
  State createState() => _PulseContainerState();
}

class _PulseContainerState extends State<PulseContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    _controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _controller.reverse();
      } else if (state == AnimationStatus.dismissed) {
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
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: widget.height,
            width: widget.width,
            constraints: widget.constraints,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              gradient: LinearGradient(colors: [
                Colors.grey.shade600.withAlpha(255 ~/ 2),
                Colors.grey.withAlpha(255 ~/ 4)
              ], stops: [
                _pulseAnimation.value - (0.2 * 10),
                _pulseAnimation.value,
              ], transform: const GradientRotation(0.5)),
            ),
          );
        });
  }
}
