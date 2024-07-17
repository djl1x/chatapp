import 'dart:io';

import 'package:chatapp/models/message.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService {
  // FIRESTORE INSTACE INITIALIZATION
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // FIREBASE STORAGE INIT
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final AuthService _auth = AuthService();
  
  // GET USER LIST
  Stream <List<Map<String, dynamic>>> getUsersStream(){
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc){
        final user = doc.data();
        return user;
      }).toList();
    });
  } 

  // SEND DM MESSAGES
  Future<void> sendMessage(String receiverID, message, String? mediaUrl, String? mediaType) async {
    //current user info
    final String currentUserID = _auth.getCurrentUser()!.uid;
    final String currentUserEmail = _auth.getCurrentUser()!.email!;
    final Timestamp timeStamp = Timestamp.now();
    
    Message newMessage = Message(
      senderID: currentUserID, 
      senderEmail: currentUserEmail, 
      receiverID: receiverID, 
      message: message, 
      timeStamp: timeStamp,
      mediaUrl: mediaUrl,
      mediaType: mediaType
      );
    //create chatroom with unique ID (user1uid_user2uid)
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore.collection('chatrooms').doc(chatRoomID).collection('messages').add(newMessage.toMap());
  }

  // SEND GROUP MESSAGES
  Future<void> sendGroupMessage(String groupId, String message, String? mediaUrl, String? mediaType) async {
    final String currentUserID = _auth.getCurrentUser()!.uid;
    final String currentUserEmail = _auth.getCurrentUser()!.email!;
    final Timestamp timeStamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: groupId,
      message: message,
      timeStamp: timeStamp,
      mediaUrl: mediaUrl,
      mediaType: mediaType
    );

    await _firestore.collection('groups').doc(groupId).collection('messages').add(newMessage.toMap());
  }
  
  // GET DM MESSAGES
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID){
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    print(chatRoomID);
    return _firestore.collection('chatrooms').doc(chatRoomID).collection('messages').orderBy('timeStamp', descending: false).snapshots();
  }

  // CREATE GROUP CHAT
  Future<void> createGroup(String groupName, List<String> memberIds) async {
    final String currentUserID = _auth.getCurrentUser()!.uid;
    memberIds.add(currentUserID);

    DocumentReference groupDoc = _firestore.collection('groups').doc();
    // document ID as the group ID
    String groupId = groupDoc.id; 
    await groupDoc.set({
      'groupId': groupId,
      'groupName': groupName,
      'members': memberIds,
      'createdBy': currentUserID,
      'createdAt': Timestamp.now(),
    });
  }

  // GET GROUPS LIST
  Stream<List<Map<String, dynamic>>> getGroupsStream() {
    final String currentUserID = _auth.getCurrentUser()!.uid;
    return _firestore.collection("groups")
        .where('members', arrayContains: currentUserID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final group = doc.data();
        return group;
      }).toList();
    });
  }

  // RETRIEVE GROUP MESSAGES
  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _firestore.collection('groups').doc(groupId).collection('messages').orderBy('timeStamp', descending: false).snapshots();
  }

  // GET MEDIA URL
  Future<String?> uploadMedia(XFile media, String type) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = _storage.ref().child('$type/$fileName');
      UploadTask uploadTask = reference.putFile(File(media.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

} 