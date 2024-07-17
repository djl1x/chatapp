import 'package:cloud_firestore/cloud_firestore.dart';

// MESSAGE MODEL TO STORE IN FIRESTORE
class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timeStamp;
  final String? mediaUrl;
  final String? mediaType;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timeStamp,
    this.mediaUrl,
    this.mediaType
  });

  Map<String, dynamic> toMap(){
    return{
      'senderID': senderID,
      'senderEmail' : senderEmail,
      'receiverID' : receiverID,
      'message' : message,
      'timeStamp' : timeStamp,
      'mediaUrl' : mediaUrl,
      'mediaType' : mediaType
    };
  } 
}