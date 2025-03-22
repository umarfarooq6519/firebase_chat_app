import 'package:flutter/material.dart';

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
              // ListTile(
              //   tileColor: Colors.white,
              //   shape: RoundedRectangleBorder(
              //     side: BorderSide(
              //       color: Theme.of(context)
              //           .colorScheme
              //           .onSurface
              //           .withValues(alpha: 0.2),
              //     ),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   title: Text('Dark Mode'),
              //   trailing: Switch(
              //     activeTrackColor: Theme.of(context).colorScheme.onSurface,
              //     // activeColor: Theme.of(context).colorScheme.primary,
              //     value: lightMode,
              //     onChanged: (bool value) {
              //       setState(() {
              //         lightMode = value;
              //       });
              //     },
              //   ),
              // ),
              // SizedBox(height: 14),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/blocked_users');
                },
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
                title: Text('Blocked Users'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              SizedBox(height: 14),
              ListTile(
                tileColor:
                    Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
