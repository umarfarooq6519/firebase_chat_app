import 'package:chat_app/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GoogleBtn extends StatelessWidget {
  GoogleBtn({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 10),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 1,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
      onPressed: () async {
        await _authService.signInWithGoogle();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/google.svg',
            width: 28,
            // height: 10,
          ),
          SizedBox(width: 6),
          Text(
            'Continue with Google',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
