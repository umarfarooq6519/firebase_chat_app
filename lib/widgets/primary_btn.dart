import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrimaryBtn extends StatelessWidget {
  const PrimaryBtn({super.key, required this.printEmail, required this.text});

  final dynamic printEmail;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.primary,
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 15),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
              width: 1,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: printEmail,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login,
              color:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Provider.of<ThemeProvider>(context, listen: false)
                        .isDarkMode
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ));
  }
}
