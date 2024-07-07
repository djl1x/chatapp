import 'package:chatapp/auth/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout(){
    AuthService _auth = AuthService();
    _auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatApp"),
        actions: [
          IconButton(onPressed: logout, icon: Icon(Icons.logout))
        ],
        
      ),
    );
  }
}