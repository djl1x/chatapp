// ignore_for_file: prefer_const_constructors

import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/view/create_group.dart';
import 'package:chatapp/view/home_page.dart';
import 'package:chatapp/view/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(){
    AuthService auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(child: Icon(Icons.message, size: 50, color: Theme.of(context).colorScheme.primary),),
              Padding(
                padding: const EdgeInsets.only(left:25.0),
                child: ListTile(
                  title: Text('H O M E'),
                  leading: Icon(Icons.home),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text('S E T T I N G S'),
                  leading: Icon(Icons.settings),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text('C R E A T E G R O U P'),
                  leading: Icon(Icons.group),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupPage()));
                  },
                ),
              ),  
            ],
          ),
          Padding(
                padding: const EdgeInsets.only(left: 25.0, bottom: 20),
                child: ListTile(
                  title: Text('L O G O U T'),
                  leading: Icon(Icons.logout),
                  onTap: (){
                    logout();
                    },
                ),
              )
        ],
      ),
    );
  }
}