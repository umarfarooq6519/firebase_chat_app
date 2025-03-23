import 'package:flutter/material.dart';
import 'package:chat_app/widgets/drawer_btn.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.handleSignOut});

  final VoidCallback handleSignOut;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerHeader(
                    child: Icon(
                      Icons.messenger,
                      size: 36,
                    ),
                  ),
                  SizedBox(height: 10),
                  DrawerBtn(
                    label: 'HOME',
                    icon: Icons.home,
                    isSignOutBtn: false,
                    onTap: () {
                      Navigator.pushNamed(context, '/chats');
                    },
                  ),
                  SizedBox(height: 10),
                  DrawerBtn(
                    label: 'SETTINGS',
                    icon: Icons.settings,
                    isSignOutBtn: false,
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
              DrawerBtn(
                label: 'SIGN OUT',
                icon: Icons.logout,
                isSignOutBtn: true,
                onTap: handleSignOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
