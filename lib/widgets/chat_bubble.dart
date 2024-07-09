// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String senderEmail;
  final String message;
  final bool isMe;

  const ChatBubble({required this.senderEmail, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              senderEmail,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          Material(
            color: isMe ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}