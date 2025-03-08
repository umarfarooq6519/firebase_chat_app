import 'package:chat_app/services/auth.service.dart';
import 'package:chat_app/services/db.service.dart';
import 'package:chat_app/widgets/custom_avatar.dart';
import 'package:chat_app/widgets/custom_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverID;
  final String receiverEmail;
  final String? receiverAvatar;

  final TextEditingController _messageController = TextEditingController();

  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverAvatar,
    required this.receiverID,
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
          return Text('loading..');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>(
                (doc) => _buildMessageItem(doc),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data['text']);
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
