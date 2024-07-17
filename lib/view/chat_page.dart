// ignore_for_file: prefer_const_constructors

import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/widgets/chat_bubble.dart';
import 'package:chatapp/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


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
  final ImagePicker _picker = ImagePicker();
  
  void _sendMessage({String? mediaUrl, String? mediaType}) async {
    if (_messageController.text.isEmpty && mediaUrl == null) return;

    if (widget.groupId != null) {
      // Handle group messages
      await _chatService.sendGroupMessage(widget.groupId!, _messageController.text, mediaUrl, mediaType);
    } else {
      // Handle direct messages
      await _chatService.sendMessage(widget.receiverUserID!, _messageController.text, mediaUrl, mediaType);
    }

    _messageController.clear();
  }

  // FUNCTION FOR OPENING GALLERY AND PICKING IMAGE OR VIDEO AND SENDING IT
  Future<void> _pickMedia(ImageSource source, String type) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      XFile? media;
      if (type == 'image') {
        media = await _picker.pickImage(source: source);
      } else if (type == 'video') {
        media = await _picker.pickVideo(source: source);
      }

    if (media != null) {
      String? mediaUrl = await _chatService.uploadMedia(media, type);
      if (mediaUrl != null) {
        _sendMessage(mediaUrl: mediaUrl, mediaType: type);
      }
    }
    }
    else{
      print('Permission Denied');
    }
    
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

    // GROUP MESSAGE DISPLAY
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
                mediaUrl: messageData['mediaUrl'],
                mediaType: messageData['mediaType'],
              );
            }).toList(),
          );
        },
      );
      // DIRECT MESSAGE DISPLAY
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
                mediaUrl: messageData['mediaUrl'],
                mediaType: messageData['mediaType'],
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
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () => _pickMedia(ImageSource.gallery, 'image'),
          ),
          IconButton(
            icon: Icon(Icons.video_library),
            onPressed: () => _pickMedia(ImageSource.gallery, 'video'),
          ),
          Expanded(
            child: MyTextField(labelText: 'send a message', obscureText: false, controller: _messageController)
          ),
          IconButton(onPressed: _sendMessage, icon: Icon(Icons.send))
        ],
      ),
    );
  }
}