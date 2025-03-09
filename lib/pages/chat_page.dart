import 'package:flutter/material.dart';
import 'package:chat_app/services/auth.service.dart';
import 'package:chat_app/services/db.service.dart';
import 'package:chat_app/widgets/custom_avatar.dart';
import 'package:chat_app/widgets/custom_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          icon: Icon(Icons.arrow_upward),
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

  Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // for sent messages
    if (data['senderID'] == _auth.currentUser!.uid) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.only(bottom: 10, top: 10, right: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.1),
                ),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(data['text']),
            ),
          ),
          CustomAvatar(
            avatarUrl: senderAvatar,
          ),
        ],
      );
    }

    return Row(
      children: [
        CustomAvatar(
          avatarUrl: receiverAvatar,
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(bottom: 10, top: 10, left: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(data['text']),
          ),
        )
      ],
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
        ),
      ),
    );
  }
}
