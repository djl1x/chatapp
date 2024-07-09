// ignore_for_file: prefer_const_constructors

import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/widgets/chat_bubble.dart';
import 'package:chatapp/widgets/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatPage extends StatefulWidget {
  final String? receiverUserEmail;
  final String? receiverUserID;
  final String? groupId;
  final String? groupName;

  const ChatPage({super.key, this.receiverUserEmail, this.receiverUserID, this.groupId, this.groupName});
  
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _auth = AuthService();
  
  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    if (widget.groupId != null) {
      // Handle group messages
      await _chatService.sendGroupMessage(widget.groupId!, _messageController.text);
    } else {
      // Handle direct messages
      await _chatService.sendMessage(widget.receiverUserID!, _messageController.text);
    }

    _messageController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail ?? widget.groupName ?? 'Chat')),
      body: Column(
        children: [
          Expanded(child: _buildMessages()),
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildMessages() {
    if (widget.groupId != null) {
      return StreamBuilder(
        stream: _chatService.getGroupMessages(widget.groupId!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error retrieving messages");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading messages . . .");
          }

          return ListView(
            children: snapshot.data!.docs.map<Widget>((doc) {
              final messageData = doc.data() as Map<String, dynamic>;
              return ChatBubble(
                senderEmail: messageData['senderEmail'],
                message: messageData['message'],
                isMe: messageData['senderID'] == _auth.getCurrentUser()!.uid,
              );
            }).toList(),
          );
        },
      );
    } else {
      return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverUserID!, _auth.getCurrentUser()!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error retrieving messages");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading messages . . .");
          }

          return ListView(
            children: snapshot.data!.docs.map<Widget>((doc) {
              final messageData = doc.data() as Map<String, dynamic>;
              return ChatBubble(
                senderEmail: messageData['senderEmail'],
                message: messageData['message'],
                isMe: messageData['senderID'] == _auth.getCurrentUser()!.uid,
              );
            }).toList(),
          );
        },
      );
    }
  }
  // message textfield
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(labelText: 'send a message', obscureText: false, controller: _messageController)
          ),
          IconButton(onPressed: _sendMessage, icon: Icon(Icons.send))
        ],
      ),
    );
  }
}