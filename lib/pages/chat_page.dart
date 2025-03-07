import 'package:chat_app/widgets/custom_avatar.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String? receiverAvatar;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
    );
  }
}
