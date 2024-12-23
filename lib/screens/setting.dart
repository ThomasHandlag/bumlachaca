import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/blocs.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GlobalUIBloc>(context);
    return SizedBox(
        child: BlocBuilder<GlobalUIBloc, GlobalUIState>(
            bloc: bloc..add(OnLoadSettings()),
            builder: (context, state) {
              return ListView(
                children: [
                  ListTile(
                    title: const Text('Theme'),
                    subtitle: Text(state.isDark! ? 'Dark' : 'Light'),
                    trailing: Switch(value: state.isDark!, onChanged: (val) {
                      bloc.add(OnChangeTheme(!state.isDark!));
                    }),
                  ),
                  ListTile(
                    title: const Text('Language'),
                    subtitle: const Text('English'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Color Palette'),
                    onTap: () {},
                  ),
                ],
              );
            }));
  }
}
