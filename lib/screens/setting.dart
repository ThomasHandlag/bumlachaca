import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Light'),
            trailing: Switch(value: false, onChanged: (val) {

            }),
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Color Palette'),
            onTap: () {
              
            },
          ),
        ],
      )
    );
  }
}



