import 'package:flutter/material.dart';
import 'package:chat_app/pages/blocked_users_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:chat_app/auth.stream.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'General Sans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Color(0xffd0e9bc),
          secondary: Color(0xffFFEDFA),
          onSurface: Colors.black.withValues(alpha: 0.8),
        ),
      ),
      home: AuthStream(),
      routes: {
        '/chats': (context) => HomePage(),
        '/settings': (context) => SettingsPage(),
        '/blocked_users': (context) => BlockedUsersPage(),
      },
    );
  }
}
