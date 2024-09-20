import 'package:flutter/material.dart';
import 'package:musicplayer/screens/home.dart';
import 'package:musicplayer/widgets/usi_button.dart';

class SignScreen extends StatelessWidget {
  const SignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(children: [
        Text('TODO: Sign in screen'),
        Text('with supabase'),
        UsiButton(onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Home()));
        })
      ])),
    );
  }
}
