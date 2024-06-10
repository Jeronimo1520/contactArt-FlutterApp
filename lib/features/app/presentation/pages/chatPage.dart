// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/features/chat/chatService.dart';
import 'package:contact_art/global/common/chatBubble.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserId;
  final String currentUserId;
  const ChatPage(
      {Key? key, required this.receiverUserName, required this.receiverUserId, required this.currentUserId})
      : super(key: key);

   @override
  _ChatPageState createState() => _ChatPageState(currentUserId);
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  late ChatService _chatService;
  final String currentUserId;

  _ChatPageState(this.currentUserId);

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(currentUserId);
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text, widget.receiverUserName);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),

          const SizedBox(height: 25)
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.currentUserId,
          widget.receiverUserId),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = data['senderId'] == widget.currentUserId
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data['senderId'] == widget.currentUserId ? 'Tú' : widget.receiverUserName),
          const SizedBox(height: 5),
          ChatBubble(message: data['message']),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, size: 25),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
