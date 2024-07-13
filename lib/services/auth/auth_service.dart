import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }
  
  // LOG IN FOR EXISTING USERS
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      _firestore.collection('Users').doc(userCredential.user!.uid).set(
        {'uid' : userCredential.user!.uid,
        'email' : email
        }
      );

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

      _firestore.collection('Users').doc(userCredential.user!.uid).set(
        {'uid' : userCredential.user!.uid,
        'email' : email
        }
      );
      return userCredential;
    }
    on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // LOG OUT
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}