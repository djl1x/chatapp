// ignore_for_file: prefer_const_constructors

import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/view/chat_page.dart';
import 'package:chatapp/widgets/my_drawer.dart';
import 'package:chatapp/widgets/usertile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatApp"),
      ),
      drawer: const MyDrawer(),

      body: _buildChatList(),
    );
  }

  Widget _buildChatList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(), 
      builder: (context, userSnapshot) {
        if (userSnapshot.hasError) {
          return const Text("Error retrieving users");
        }
        
        if (userSnapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading . . .");
        }

        return StreamBuilder(
          stream: _chatService.getGroupsStream(),
          builder: (context, groupSnapshot) {
            if (groupSnapshot.hasError) {
              return const Text("Error retrieving groups");
            }

            if (groupSnapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading groups . . .");
            }

            List<Widget> chatListItems = [
              ...userSnapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
              ...groupSnapshot.data!.map<Widget>((groupData) => _buildGroupListItem(groupData, context)).toList(),
            ];

             return ListView(
              children: chatListItems,
            );
          },
        );
      }
      );
  }
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context){
    if (userData["email"] != _authService.getCurrentUser()!.email){
    return UserTile(
      text: userData["email"],
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => ChatPage(receiverUserEmail: userData['email'], receiverUserID: userData['uid'],)));
      },
    );
    }
    else {
      return Container();
    }
  }

  Widget _buildGroupListItem(Map<String, dynamic> groupData, BuildContext context) {
    return UserTile(
      text: groupData["groupName"],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              groupId: groupData['groupId'],
              groupName: groupData['groupName'],
            ),
          ),
        );
      },
    );
  }
}