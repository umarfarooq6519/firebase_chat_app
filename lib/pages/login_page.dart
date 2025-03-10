import 'package:chat_app/services/auth.service.dart';
import 'package:chat_app/widgets/google_btn.dart';
import 'package:chat_app/widgets/custom_input_field.dart';
import 'package:chat_app/widgets/primary_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
    userEmail = FirebaseAuth.instance.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/chat_app_logo.json',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 20),
                Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 32,
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
                Divider(
                  indent: 30,
                  endIndent: 30,
                  height: 60,
                ),
                SizedBox(
                  width: double.infinity,
                  child: GoogleBtn(),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? '),
                    InkWell(
                      onTap: widget.onToggle,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
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
    );
  }
}
