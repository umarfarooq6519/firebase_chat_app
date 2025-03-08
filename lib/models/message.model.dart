import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final Timestamp timestamp;
  final String senderID;
  final String senderEmail;
  final String receiverID;

  Message({
    required this.text,
    required this.timestamp,
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'timestamp': timestamp,
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
    };
  }
}
