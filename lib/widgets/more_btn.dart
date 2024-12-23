import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MoreButton extends StatelessWidget {
  const MoreButton({super.key, required this.children});
  final List<PopupMenuItem> children;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: PopupMenuButton(
            itemBuilder: (BuildContext context) => children.map((e) {
              return e;
            }).toList(),
            style: const ButtonStyle(
              fixedSize: WidgetStatePropertyAll(Size(20, 20)),
            ),
            icon: const Icon(
              FontAwesomeIcons.ellipsis,
              size: 15,
            ),
          )));
}
