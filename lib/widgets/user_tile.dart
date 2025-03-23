import 'package:chat_app/themes/theme_provider.dart';
import 'package:chat_app/widgets/custom_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String? avatarUrl;

  const UserTile({
    super.key,
    required this.onTap,
    required this.text,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
      highlightColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            CustomAvatar(
              avatarUrl: avatarUrl,
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: Provider.of<ThemeProvider>(context, listen: false)
                        .isDarkMode
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
