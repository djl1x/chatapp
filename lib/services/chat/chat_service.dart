import 'package:chatapp/models/message.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // FIRESTORE INSTACE INITIALIZATION
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  //
  Stream <List<Map<String, dynamic>>> getUsersStream(){
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc){
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, message) async {
    //current user info
    final String currentUserID = _auth.getCurrentUser()!.uid;
    final String currentUserEmail = _auth.getCurrentUser()!.email!;
    final Timestamp timeStamp = Timestamp.now();
    
    Message newMessage = Message(
      senderID: currentUserID, 
      senderEmail: currentUserEmail, 
      receiverID: receiverID, 
      message: message, 
      timeStamp: timeStamp);
    //create chatroom with unique ID
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    //

    await _firestore.collection('chatrooms').doc(chatRoomID).collection('messages').add(newMessage.toMap());
  }
  
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID){
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    print(chatRoomID);
    return _firestore.collection('chatrooms').doc(chatRoomID).collection('messages').orderBy('timeStamp', descending: false).snapshots();
  }
} 