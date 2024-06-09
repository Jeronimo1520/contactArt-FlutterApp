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
  User? _user;
  String? _userId;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo salió mal');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList());
        });
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_user?.email != data['email']) {
      return ListTile(
        title: Text(data['userName']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserId: document.id,
                receiverUserName: data['userName'],
                currentUserId: _userId,
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  void _loadUserData() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    User user = userProvider.user;
    String userId = userProvider.userId;

    _user = user;
    _userId = userId;

    print("user profile: ${_user.toString()}");
    print("userId profile: $_userId");

    setState(() {});
  }
}
