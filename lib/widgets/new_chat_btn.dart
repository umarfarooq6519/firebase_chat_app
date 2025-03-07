import 'package:flutter/material.dart';

class NewChatBtn extends StatelessWidget {
  const NewChatBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
      child: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
