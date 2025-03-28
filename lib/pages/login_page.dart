import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:chat_app/services/auth.service.dart';
import 'package:chat_app/widgets/google_btn.dart';
import 'package:chat_app/widgets/custom_input_field.dart';
import 'package:chat_app/widgets/primary_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onToggle;
  const LoginPage({super.key, required this.onToggle});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? userEmail;

  final AuthService _auth = AuthService();

  Future<void> handleSignUp() async {
    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    if (email.trim().isEmpty || password.trim().isEmpty) return;

    await _auth.signInWithEmailPassword(email, password).then((e) {
      print('User Authenticated: $email');
    }).catchError((e) {
      throw Exception('handleSignIn() error $e');
    });
  }

  @override
  void initState() {
    super.initState();
    userEmail = _auth.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/chat_app_logo.json',
                    width: 220,
                    height: 220,
                  ),
                  SizedBox(height: 0),
                  Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      fontSize: 26,
                      height: 0,
                      fontFamily: 'Clash Display',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomInputField(
                      controller: _emailController,
                      hintText: 'E-mail',
                      obscureText: false),
                  SizedBox(height: 10),
                  CustomInputField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: true),
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryBtn(
                      printEmail: handleSignUp,
                      text: 'Continue',
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Divider(
                          endIndent: 10,
                          indent: 10,
                          height: 60,
                        ),
                      ),
                      Text('Or'),
                      Flexible(
                        child: Divider(
                          indent: 10,
                          endIndent: 10,
                          height: 60,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: GoogleBtn(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? '),
                      InkWell(
                        onTap: widget.onToggle,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
