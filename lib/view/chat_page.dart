// ignore_for_file: prefer_const_constructors

import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/widgets/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserID});
  
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _auth = AuthService();
  
  void sendMessage() async {
    print(_auth.getCurrentUser()!.uid +  widget.receiverUserID);
    if (_messageController.text.isNotEmpty){
        await _chatService.sendMessage(widget.receiverUserID, _messageController.text);

        //CLEAR THE MESSAGE BOX AFTER SENDING
        _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail)),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessages(_auth.getCurrentUser()!.uid, widget.receiverUserID), 
      
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading . . .');
        }

        return ListView(
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      });
  }
  // message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment;
    if (data['senderID'] == _auth.getCurrentUser()!.uid) {
      alignment = Alignment.centerRight;
    }
    else{
      alignment = Alignment.centerLeft;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        border: Border.all(),
        borderRadius: BorderRadius.circular(10)
      ),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderID'] == _auth.getCurrentUser()!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(data['senderEmail'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),textAlign: TextAlign.start,),
          SizedBox(height: 10),
          Text(data['message'], style: TextStyle(color: Colors.black, fontSize: 18),),
        ],
      ),
    );
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
          IconButton(onPressed: sendMessage, icon: Icon(Icons.send))
        ],
      ),
    );
  }
}