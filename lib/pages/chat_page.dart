import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth.service.dart';
import 'package:chat_app/services/db.service.dart';
import 'package:chat_app/widgets/custom_avatar.dart';
import 'package:chat_app/widgets/custom_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  final String receiverID;
  final String receiverEmail;
  final String? receiverAvatar;
  final String? senderAvatar;

  final TextEditingController _messageController = TextEditingController();

  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverAvatar,
    required this.receiverID,
    this.senderAvatar,
  });

  void sendMessage() async {
    final message = _messageController.value.text;

    if (message.trim().isEmpty) return; // return if empty message

    _messageController.clear();

    await _db.sendMessage(receiverID, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _chatAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _getMessageList(),
              ),
              _inputMsgField(context),
            ],
          ),
        ),
      ),
    );
  }

  Row _inputMsgField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomInputField(
            controller: _messageController,
            hintText: 'Start typing...',
            obscureText: false,
          ),
        ),
        IconButton(
          style: ButtonStyle(
            side: WidgetStatePropertyAll(
              BorderSide(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          onPressed: sendMessage,
          icon: Icon(
            Icons.arrow_upward,
            color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  StreamBuilder _getMessageList() {
    final senderID = _auth.currentUser!.uid;

    return StreamBuilder(
      stream: _db.getMessages(senderID, receiverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('error displaying messages');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages 😔'));
        }

        return ListView(
          padding: EdgeInsets.only(bottom: 20),
          children: snapshot.data!.docs
              .map<Widget>(
                (doc) => _buildMessageItem(doc, context),
              )
              .toList(),
        );
      },
    );
  }

  // show options
  void _showOptions(BuildContext context, String messageID, String userID) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // report button
              ListTile(
                leading: Icon(Icons.flag),
                title: Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(context, messageID, userID);
                },
              ),

              // block button
              ListTile(
                leading: Icon(Icons.block),
                title: Text('Block'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, userID);
                },
              ),

              // cancel button
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  // report message
  void _reportMessage(BuildContext context, String messageID, String userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report User'),
        content: Text('Are you sure you want to rpoert the user?'),
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
              _db.reportMessage(messageID, userID);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User Reported'),
                ),
              );
            },
            child: Text(
              'Report',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  // block user
  void _blockUser(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block User'),
        content: Text('Are you sure you want to block the user?'),
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
              _db.blockUser(userID);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User Blocked'),
                ),
              );
            },
            child: Text(
              'Block',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final bool isSent = data['senderID'] == _auth.currentUser!.uid;

    return GestureDetector(
      onLongPress: () {
        if (!isSent) {
          _showOptions(context, doc.id, data['senderID']);
        }
        // Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment:
            isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSent)
            CustomAvatar(avatarUrl: receiverAvatar), // Receiver's avatar

          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
                top: 10,
                left: isSent ? 0 : 10,
                right: isSent ? 10 : 0,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.circular(10),
                color: isSent
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                data['text'],
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),

          if (isSent) CustomAvatar(avatarUrl: senderAvatar), // Sender's avatar
        ],
      ),
    );
  }

  AppBar _chatAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomAvatar(
            avatarUrl: receiverAvatar,
          ),
        )
      ],
      centerTitle: true,
      title: Text(
        receiverEmail,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
