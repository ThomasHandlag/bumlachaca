import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:platform/platform.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:usicat/helper/err_log.dart';
import 'package:usicat/layouts/sign_layout.dart';
import 'package:usicat/main.dart';
import 'package:usicat/widgets/snackbar_content.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final platform = const LocalPlatform();
  final supabase = Supabase.instance.client;
  bool _isPasswordVisible = false;
  int _passwordMeasure = 0;
  bool _showProgress = false;

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter some text";
    }
    // email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  int passwordEvaluator(String? value) {
    int passwordStrength = 0;
    if (value == null || value.isEmpty) {
      return passwordStrength;
    }

    if (value.length >= 8) {
      passwordStrength++;
    }

    if (RegExp(r'[A-Z]').hasMatch(value)) {
      passwordStrength++;
    }

    if (RegExp(r'[a-z]').hasMatch(value)) {
      passwordStrength++;
    }

    if (RegExp(r'[0-9]').hasMatch(value)) {
      passwordStrength++;
    }

    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      passwordStrength++;
    }

    return passwordStrength;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter password";
    }
    // password validation
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  void onCompletePassword() {
    setState(() {
      _passwordMeasure = passwordEvaluator(_passwordController.text);
    });
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter confirm password";
    }
    // password validation
    if (value != _passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<bool> signUpWithEmail() async {
    setState(() => _showProgress = true);
    try {
      await supabase.from('user').insert({
        'email': _emailController.text,
        'password': _passwordController.text
      }).then((value) {
        sleep(const Duration(seconds: 2));
        setState(() => _showProgress = false);
        // context.pushReplacement('/home');
      });
    } catch (e) {
      setState(() => _showProgress = false);

      if (e.runtimeType == PostgrestException) {
        final error = e as PostgrestException;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: SnackbarContent(
                message: fromErrorCode(error.code, context),
                icon: const Icon(Icons.error, color: Colors.red)),
            backgroundColor: Colors.black));
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SignLayout(
      showLoading: _showProgress,
      child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 180,
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
                                Text("Sign Up",
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
                                if (_formKey.currentState!.validate()) {
                                  debugPrint("value: ${_emailController.text}");
                                }
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
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            TextFormField(
                              obscureText: _isPasswordVisible,
                              controller: _passwordController,
                              validator: passwordValidator,
                              onChanged: (value) => onCompletePassword(),
                              onEditingComplete: () {
                                _formKey.currentState!.validate();
                              },
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  fillColor: Colors.white,
                                  error: null,
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
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            PasswordIndicator(
                              passwordMeasure: _passwordMeasure,
                              showProgress: _showProgress,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _confirmPasswordController,
                              validator: confirmPasswordValidator,
                              onEditingComplete: () {
                                if (_formKey.currentState!.validate()) {}
                              },
                              decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  fillColor: Colors.white,
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelStyle: const TextStyle(
                                      color: Color(0xFF05001C), fontSize: 14)),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                const Color(0xFF05001C)),
                                        shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10)))),
                                    child: const Text(
                                      "Continue as Guest",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        signUpWithEmail();
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                const Color(0xFF05001C)),
                                        shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10)))),
                                    child: const Text(
                                      "Sign up",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            const Text("or"),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton.filled(
                                    style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.white)),
                                    onPressed: () {
                                      // _signInWithDiscord().then((value) => log(
                                      //     "Discord Sign In: ${supabase.auth.currentUser == null}"));
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
                                    // _signInWithGoogle().then(
                                    //     (value) => log("Google Sign In: $value"));
                                  },
                                  icon: const FaIcon(FontAwesomeIcons.google,
                                      size: 18, color: Color(0xFF05001C)),
                                ),
                                const SizedBox(width: 10),
                                IconButton.filled(
                                    style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.white)),
                                    onPressed: () {
                                      // _signInWithGithub().then(
                                      //     (value) => log("Github Sign In: $value"));
                                    },
                                    icon: const FaIcon(FontAwesomeIcons.github,
                                        size: 18, color: Color(0xFF05001C)),
                                    padding: const EdgeInsets.all(10)),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?"),
                                TextButton(
                                    onPressed: () {
                                      context.pushReplacement('/signin');
                                    },
                                    style: ButtonStyle(
                                      padding: WidgetStateProperty.all(
                                          const EdgeInsets.all(0)),
                                    ),
                                    child: const Text("Sign In",
                                        style: TextStyle(
                                            color: Color(0xFF05001C),
                                            fontWeight: FontWeight.bold)))
                              ],
                            )
                          ],
                        )))
              ])));
}

class PasswordIndicator extends StatefulWidget {
  const PasswordIndicator(
      {super.key, required this.passwordMeasure, required this.showProgress});
  final int passwordMeasure;
  final bool showProgress;
  @override
  State<StatefulWidget> createState() => PasswordIndicatorState();
}

class PasswordIndicatorState extends State<PasswordIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 25,
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            OverflowBar(
              alignment: MainAxisAlignment.start,
              spacing: 2,
              children: [
                for (int i = 0; i < 5; i++)
                  Container(
                    width: 40,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.only(
                          topLeft:
                              i == 0 ? const Radius.circular(5) : Radius.zero,
                          bottomLeft:
                              i == 0 ? const Radius.circular(5) : Radius.zero,
                          topRight:
                              i == 4 ? const Radius.circular(5) : Radius.zero,
                          bottomRight:
                              i == 4 ? const Radius.circular(5) : Radius.zero,
                        )),
                  )
              ],
            ),
            OverflowBar(
              alignment: MainAxisAlignment.start,
              spacing: 2,
              children: [
                for (int i = 1; i <= widget.passwordMeasure; i++)
                  if (i == 1)
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.shade700,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                    )
                  else if (i == 5)
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.shade700,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                      ),
                    )
                  else
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.shade700,
                      ),
                    ),
              ],
            )
          ],
        ));
  }
}
