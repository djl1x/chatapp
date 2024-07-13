// ignore_for_file: prefer_const_constructors

import 'package:chatapp/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChatBubble extends StatefulWidget {
  final String senderEmail;
  final String message;
  final bool isMe;
  final String? mediaUrl;
  final String? mediaType;

  const ChatBubble({required this.senderEmail, required this.message, required this.isMe, this.mediaUrl, this.mediaType,});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video' && widget.mediaUrl != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl!));
      _initializeVideoPlayerFuture = _videoController.initialize();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.senderEmail,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ), 
          ),
          if (widget.mediaUrl != null && widget.mediaType == 'image')
            Image.network(widget.mediaUrl!),
          if (widget.mediaUrl != null && widget.mediaType == 'video')
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: [ 
                        AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayerScreen(url: widget.mediaUrl!),
                        ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          if (widget.message != "")
            Material(
              color: widget.isMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  widget.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}