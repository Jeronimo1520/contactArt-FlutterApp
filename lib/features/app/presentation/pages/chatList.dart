import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/controllers/UserProvider.dart';
import 'package:contact_art/features/app/presentation/pages/chatPage.dart';
import 'package:contact_art/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:contact_art/models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  @override
  Widget build(BuildContext context) {
    //  final userProvider = context.watch<UserProvider>();
     final _userId = "CrjD6iVL5WbIL6MDN9aWdj0cZu63";
    return Scaffold(
      body: _buildUserList(_userId),
    );
  }

  Widget _buildUserList(String? _userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('id', isGreaterThanOrEqualTo: _userId)
          .where('id', isLessThanOrEqualTo: '${_userId!}\uf8ff')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            if (data['id'].contains(_userId)) {
              return ListTile(
                title: Text(data['receiverName']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverUserId: data['receiverId'],
                        receiverUserName: data['receiverName'],
                        currentUserId: _userId,
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container(
                child: const Text("No chats found"),
              );
            }
          }).toList(),
        );
      },
    );
  }

}
