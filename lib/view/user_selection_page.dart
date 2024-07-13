import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSelectionPage extends StatefulWidget {
  @override
  _UserSelectionPageState createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  List<String> selectedUsers = [];

  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final ChatService chatService = ChatService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Members'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context, selectedUsers);
            },
          )
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user['uid'];
              final userName = user['email'];
              
              return ListTile(
                title: Text(userName),
                trailing: Checkbox(
                  value: selectedUsers.contains(userId),
                  onChanged: (isSelected) {
                    setState(() {
                      if (isSelected == true) {
                        selectedUsers.add(userId);
                      } else {
                        selectedUsers.remove(userId);
                      }
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}