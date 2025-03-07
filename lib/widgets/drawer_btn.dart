import 'package:flutter/material.dart';

class DrawerBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSignOutBtn; // for displaying red signout btn

  const DrawerBtn({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isSignOutBtn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onTap,
        style: ButtonStyle(
          alignment: Alignment.centerLeft,
          // backgroundColor: WidgetStatePropertyAll(Colors.amber),
        ),
        label: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            label,
            style: TextStyle(
              color: isSignOutBtn
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w400,
              fontSize: 18,
              letterSpacing: 3,
            ),
          ),
        ),
        icon: Icon(
          icon,
          size: 20,
          color: isSignOutBtn
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
