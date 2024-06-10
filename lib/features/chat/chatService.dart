import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/controllers/userProvider.dart';
import 'package:contact_art/models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Message.dart';

class ChatService extends ChangeNotifier {
  String currentUserId;
  final Timestamp timestamp = Timestamp.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatService(String userId) : currentUserId = userId;
  
  Future<void> sendMessage(String receiverId, String message, String receiverName) async {
    Message newMessage = Message(
        senderId: currentUserId,
        receiverName: receiverName,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatId = ids.join('_');

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String? currentUserId, String receiverId) {
    List<String?> ids = [currentUserId, receiverId];
    ids.sort();
    String chatId = ids.join('_');

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
