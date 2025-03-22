import 'package:chat_app/services/db.service.dart';
import 'package:chat_app/widgets/user_tile.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BLOCKED USERS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Clash Display',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _db.getBlockedUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading blocked users'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No blocked users'));
            }

            final blockedUsers = snapshot.data!;

            return ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return UserTile(
                  onTap: () {
                    _showUnblockDialog(context, user['uid']);
                  },
                  text: user['email'],
                  avatarUrl: user['avatarUrl'],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showUnblockDialog(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unblock User'),
        content: Text('Are you sure you want to unblock the user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _db.unblockUser(userID);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User Unblocked'),
                ),
              );
            },
            child: Text(
              'Unblock',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
