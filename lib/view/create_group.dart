// ignore_for_file: prefer_const_constructors

import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/view/user_selection_page.dart';
import 'package:chatapp/widgets/my_button.dart';
import 'package:chatapp/widgets/my_textfield.dart';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final ChatService _chatService = ChatService();
  List<String> selectedMembers = [];
  void createGroup() async {
    final String groupName = _groupNameController.text.trim();
    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Group name cannot be empty')));
      return;
    }

    if (selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select at least one member')));
      return;
    }

    await _chatService.createGroup(groupName, selectedMembers);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Group created successfully')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create A New Group', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 20),
              MyTextField(labelText: 'Group Name', obscureText: false, controller: _groupNameController,),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final selected = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserSelectionPage()),
                  );
                  if (selected != null) {
                    setState(() {
                      selectedMembers = selected;
                    });
                  }
                },
                child: Text('Select Members'),
              ),
              SizedBox(height: 30,),
              MyButton(text: 'Create Group', onTap: createGroup)
          
            ],
          ),
        ),
      ),
    );
  }
}