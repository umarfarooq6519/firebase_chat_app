import 'package:chat_app/models/message.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all users stream
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

  // Send message to chat room
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

  // Get chat room messages stream
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

  // Get all unblocked users stream
  Stream<List<Map<String, dynamic>>> getUnblockedUsersStream() {
    final currentUser = _auth.currentUser;

    return _db
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked users')
        .snapshots()
        .asyncMap((snapshot) async {
      // get all unblocked users
      final blockedUserIDs = snapshot.docs.map((doc) => doc.id).toList();

      // get all users
      final userSnapshot = await _db.collection('users').get();

      // return a stream list excluding current user and blocked users
      return userSnapshot.docs
          .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUserIDs.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  // Report users
  Future<void> reportUser(String msgID, String userID) async {
    final currentUser = _auth.currentUser;

    final report = {
      'reportedBy': currentUser!.uid,
      'messageID': msgID,
      'msgOwnerID': userID,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _db.collection('reports').add(report);
  }

  // Block users
  Future<void> blockUser(String userID) async {
    final currentUser = _auth.currentUser;

    await _db
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked users')
        .doc(userID)
        .set({});
    notifyListeners();
  }

  // Unblock users
  Future<void> unblockUser(String userID) async {
    final currentUser = _auth.currentUser;

    await _db
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked users')
        .doc(userID)
        .delete();

    notifyListeners();
  }

  // Get all blocked users stream
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream() {
    final currentUser = _auth.currentUser;

    return _db
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked users')
        .snapshots()
        .asyncMap((snapshot) async {
      // get list of blocked user IDs
      final blockedUserIDs = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
          blockedUserIDs.map((id) => _db.collection('users').doc(id).get()));

      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
