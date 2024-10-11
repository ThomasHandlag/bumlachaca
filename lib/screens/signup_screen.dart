import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:platform/platform.dart';
import 'package:usicat/layouts/sign_layout.dart';

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

  bool _isPasswordVisible = false;

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

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter some text";
    }
    // password validation
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }

    if (!RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(value)) {
      return "Password must contain at least one uppercase letter, one lowercase letter, one number and one special character";
    }
    return null;
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

  @override
  Widget build(BuildContext context) => SignLayout(
      child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Sign In",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF05001C)))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
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
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        TextFormField(
                          obscureText: _isPasswordVisible,
                          controller: _passwordController,
                          validator: passwordValidator,
                          onEditingComplete: () {
                            if (_formKey.currentState!.validate()) {}
                          },
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
                                      _isPasswordVisible = !_isPasswordVisible;
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
                        TextFormField(
                          obscureText: _isPasswordVisible,
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
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  icon: Icon(_isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              labelStyle: const TextStyle(
                                  color: Color(0xFF05001C), fontSize: 14)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () {},
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
                                    debugPrint(
                                        "value: ${_emailController.text}");
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
                                  "Sign up",
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
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.white)),
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
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                                onPressed: () {
                                  context.go('signup');
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
                    ))
              ])));
}

class PasswordIndicator extends StatefulWidget {
  const PasswordIndicator({super.key, required this.password});
  final String password;
  @override
  State<StatefulWidget> createState() => PasswordIndicatorState();
}

class PasswordIndicatorState extends State {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        padding: const EdgeInsets.all(10),
        child: OverflowBar(
          spacing: 5,
          children: [],
        ));
  }
}
