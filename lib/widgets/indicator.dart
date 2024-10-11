import 'package:flutter/material.dart';

class SlideIndicator extends StatefulWidget {
  const SlideIndicator({super.key, required this.index, required this.onPress});
  final int index;
  final ValueChanged<int> onPress;
  @override
  State<StatefulWidget> createState() => IndicatorState();
}

class IndicatorState extends State<SlideIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        padding: const EdgeInsets.all(10),
        child: OverflowBar(
          spacing: 5,
          children: [
            Indicator(
                isSelected: widget.index == 0,
                onPress: () => widget.onPress(0),
                isFinal: false),
            Indicator(
                isSelected: widget.index == 1,
                onPress: () => widget.onPress(1),
                isFinal: false),
            Indicator(
                isSelected: widget.index == 2,
                onPress: () => widget.onPress(2),
                isFinal: false),
            Indicator(
                isSelected: widget.index == 3,
                onPress: () => widget.onPress(3),
                isFinal: false),
            Indicator(
                isSelected: widget.index == 4,
                onPress: () => widget.onPress(4),
                isFinal: false)
          ],
        ));
  }
}

class Indicator extends StatelessWidget {
  const Indicator(
      {super.key,
      required this.isSelected,
      required this.onPress,
      required this.isFinal});
  final VoidCallback onPress;
  final bool isSelected;
  final bool isFinal;
  final double borderRadius = 15.0;
  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.black),
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(borderRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 15,
          width: isSelected ? 30.0 : 10.0,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
      ));
}
