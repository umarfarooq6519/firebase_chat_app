import 'package:flutter/material.dart';
import 'package:chat_app/services/auth.service.dart';
import 'package:chat_app/widgets/google_btn.dart';
import 'package:chat_app/widgets/custom_input_field.dart';
import 'package:chat_app/widgets/primary_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onToggle;

  const SignupPage({super.key, required this.onToggle});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? userEmail;

  final AuthService _auth = AuthService();

  Future<void> handleSignUp() async {
    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    if (email.trim().isEmpty || password.trim().isEmpty) return;

    await _auth.signUpWithEmailPassword(email, password).then((e) {
      print('User account created: $email');
    }).catchError((e) {
      throw Exception('handleSignUp() error $e');
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
                  "Create an account",
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Clash Display',
                    height: 0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                CustomInputField(
                    controller: _emailController,
                    hintText: 'user@example.com',
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
                    Text('Already have an account? '),
                    InkWell(
                      onTap: widget.onToggle,
                      child: Text(
                        'Login now',
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
