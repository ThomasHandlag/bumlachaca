import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Default extends StatefulWidget {
  const Default({super.key});

  @override
  State<StatefulWidget> createState() => DefaultState();
}

class DefaultState extends State<Default> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation bounceAnimation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    bounceAnimation = Tween(begin: 0.9, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.bounceOut));
    controller.repeat();
  }

  Future<String?> getLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  // @override
  // void reassemble() {

  //   super.reassemble();
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getLocalData().then((value) {
      if (value != null) {
        final LocalUser user = LocalUser.fromJson(jsonDecode(value));
        GlobalAuthState.user = user;
        GoRouter.of(context).go('/home');
      } else {
        GoRouter.of(context).go('/signin');
      }
    });
    return Scaffold(body: Container());
  }
}


class LocalUser extends Equatable {
  const LocalUser({
    required this.id,
    required this.email,
    this.username = "",
    required this.password
  });

  final int id;
  final String email;
  final String username;
  final String password;

  @override
  List<Object> get props => [id, email, username, password];

  factory LocalUser.fromJson(Map<String, dynamic> json) {
    return LocalUser(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password
    };
  }
}


class GlobalAuthState {
  GlobalAuthState({this.token = ""});
  static LocalUser? user;
  final String token;

  GlobalAuthState copyWith({String? token}) {
    return GlobalAuthState(
      token: token ?? this.token,
    );
  }

  LocalUser? get getUser => user;
}