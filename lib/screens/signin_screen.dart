import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:usicat/layouts/sign_layout.dart';
import 'package:platform/platform.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:usicat/main.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  SigninScreenState createState() => SigninScreenState();
}

class SigninScreenState extends State<SignScreen> {
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Invalid email";
    }
    // email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return "Invalid email";
    }

    return null;
  }

  final platform = const LocalPlatform();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  final supabase = Supabase.instance.client;

  void _signInWithPassword() async {
    setState(
      () => _isSyncing = true,
    );
    await supabase
        .from('user')
        .select()
        .eq('email', _emailController.text)
        .then((value) {
      setState(
        () => _isSyncing = false,
      );
      if (value.isNotEmpty) {
        if (value[0]["password"] == _passwordController.text &&
            value[0]["email"] == _emailController.text) {
          context.pushReplacement('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Invalid password"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Account not found"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)));
      }
    });
  }

  void _continueAsGuest() {
    context.go('/home');
  }

  @override
  void initState() {
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      // todo: handle auth state change
      if (event == AuthChangeEvent.signedIn) {
        debugPrint(supabase.auth.currentUser?.email);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<bool> _signInWithGoogle() async {
    return await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
    );
  }

  Future<bool> _signInWithDiscord() async {
    return await supabase.auth.signInWithOAuth(
      OAuthProvider.discord,
      authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
    );
  }

  Future<bool> _signInWithGithub() async {
    return await supabase.auth.signInWithOAuth(
      OAuthProvider.github,
      authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
    );
  }

  bool _isSyncing = false;

  @override
  Widget build(BuildContext context) => SignLayout(
      showLoading: _isSyncing,
      child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 200,
                ),
                const SizedBox(
                  height: 10,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Sign In",
                                  style: TextStyle(
                                      fontSize: MusicAppThemeData.of(context)
                                          .textSizeScheme
                                          .headlineMedium,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF05001C)))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: emailValidator,
                            autocorrect: true,
                            onEditingComplete: () {
                              if (_formKey.currentState!.validate()) {}
                            },
                            controller: _emailController,
                            decoration: InputDecoration(
                                labelText: "Email",
                                fillColor: Colors.white,
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelStyle: const TextStyle(
                                    color: Colors.black54, fontSize: 14)),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          TextFormField(
                            obscureText: _isPasswordVisible,
                            controller: _passwordController,
                            decoration: InputDecoration(
                                labelText: "Password",
                                fillColor: Colors.white,
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(_isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
                                labelStyle: const TextStyle(
                                    color: Color(0xFF05001C), fontSize: 14)),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    _continueAsGuest();
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                          const Color(0xFF05001C)),
                                      shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)))),
                                  child: const Text(
                                    "Continue as Guest",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _signInWithPassword();
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                          const Color(0xFF05001C)),
                                      shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)))),
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          const Text("or"),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton.filled(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    _signInWithDiscord();
                                  },
                                  icon: const Icon(
                                    Icons.discord,
                                    color: Color(0xFF05001C),
                                  )),
                              const SizedBox(width: 10),
                              if (platform.isIOS || platform.isMacOS)
                                Row(
                                  children: [
                                    IconButton.filled(
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.white)),
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.apple,
                                          color: Color(0xFF05001C),
                                        )),
                                    const SizedBox(width: 10)
                                  ],
                                ),
                              IconButton.filled(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.white)),
                                onPressed: () {
                                  _signInWithGoogle();
                                },
                                icon: const FaIcon(FontAwesomeIcons.google,
                                    size: 18, color: Color(0xFF05001C)),
                              ),
                              const SizedBox(width: 10),
                              IconButton.filled(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    _signInWithGithub();
                                  },
                                  icon: const FaIcon(FontAwesomeIcons.github,
                                      size: 18, color: Color(0xFF05001C)),
                                  padding: const EdgeInsets.all(10)),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                  onPressed: () {
                                    context.pushReplacement('/signup');
                                  },
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                        const EdgeInsets.all(0)),
                                  ),
                                  child: const Text("Sign Up",
                                      style: TextStyle(
                                          color: Color(0xFF05001C),
                                          fontWeight: FontWeight.bold)))
                            ],
                          )
                        ],
                      )),
                )
              ])));
}
