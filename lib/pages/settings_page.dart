import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool lightMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Clash Display',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.2),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: Provider.of<ThemeProvider>(context, listen: false)
                            .isDarkMode
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                trailing: Switch(
                  activeTrackColor:
                      Provider.of<ThemeProvider>(context, listen: false)
                              .isDarkMode
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.onSurface,
                  activeColor: Theme.of(context).colorScheme.onSurface,
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (bool value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                ),
              ),
              SizedBox(height: 14),
              // ListTile(
              //   onTap: () {
              //     Navigator.pushNamed(context, '/blocked_users');
              //   },
              //   tileColor: Theme.of(context).colorScheme.error,
              //   shape: RoundedRectangleBorder(
              //     side: BorderSide(
              //       color: Theme.of(context)
              //           .colorScheme
              //           .onSurface
              //           .withValues(alpha: 0.2),
              //     ),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   title: Text('Blocked Users'),
              //   trailing: Icon(Icons.arrow_forward_ios),
              // ),
              // SizedBox(height: 14),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/blocked_users');
                },
                tileColor:
                    Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  'Blocked Users',
                  style: TextStyle(
                    color: Provider.of<ThemeProvider>(context, listen: false)
                            .isDarkMode
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.surface,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.surface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
