import 'package:chat_app/models/message.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    final String currentUser = _auth.currentUser!.uid;

    return _db.collection("users").snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final user = doc.data();

            return user;
          })
          .where((user) => user['uid'] != currentUser)
          .toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create new message
    Message newMessage = Message(
      text: message,
      timestamp: timestamp,
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
    );

    // construct chat room id for both users
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // send the message using chat room ID
    await _db
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection("messages")
        .add(
          newMessage.toMap(),
        );
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // construct chat room id for both users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // get messages using chat room ID
    return _db
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
