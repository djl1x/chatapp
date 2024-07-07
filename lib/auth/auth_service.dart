import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // LOG IN FOR EXISTING USERS
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  // SIGN UP
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    }
    on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  // LOG OUT
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}