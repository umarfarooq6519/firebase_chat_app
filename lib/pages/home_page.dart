import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/db.service.dart';
import 'package:chat_app/widgets/custom_avatar.dart';
import 'package:chat_app/widgets/custom_drawer.dart';
import 'package:chat_app/widgets/new_chat_btn.dart';
import 'package:chat_app/widgets/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth.service.dart';
import 'package:chat_app/widgets/drawer_btn.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  String? userEmail;
  String? userAvatar;

  @override
  void initState() {
    super.initState();
    userEmail = _auth.currentUser!.email;
    userAvatar = _auth.currentUser!.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: CustomDrawer(handleSignOut: _auth.signOut),
      body: _displayUsersList(),
      floatingActionButton: NewChatBtn(),
    );
  }

  StreamBuilder _displayUsersList() {
    // fetch and display users
    return StreamBuilder(
      stream: _db.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        // Ensure snapshot.data is not null
        final List<Map<String, dynamic>> users = snapshot.data ?? [];

        // Check if list is empty
        if (users.isEmpty) {
          return Center(child: Text('No users found 😔'));
        }

        return ListView(
          children: users.map(
            (userData) {
              return _userListItem(userData, context);
            },
          ).toList(),
        );
      },
    );
  }

  UserTile _userListItem(Map<String, dynamic> userData, BuildContext context) {
    final String receiverID = userData['uid'];
    final String receiverEmail = userData['email'];
    final String? receiverAvatar = userData['avatarUrl'];

    return UserTile(
      text: receiverEmail,
      avatarUrl: receiverAvatar,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: receiverEmail,
              receiverID: receiverID,
              receiverAvatar: receiverAvatar,
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Chats',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CustomAvatar(
              avatarUrl: userAvatar,
            )),
      ],
    );
  }
}
