import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String receiverName;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.receiverName,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverName': receiverName,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
