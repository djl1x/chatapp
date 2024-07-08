// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/widgets/my_button.dart';
import 'package:chatapp/widgets/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required this.onTap});

  final void Function()? onTap;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void login(BuildContext context) async {
    print('Button tapped');
    final authService = AuthService();

    try{
      await authService.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
    }
    catch (e){
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ChatApp',
                style: TextStyle(
                  fontSize: 30
                ),
              ),
              SizedBox(height: 20,),
              Icon(
                Icons.message_outlined,
                size: 50
              ),

              SizedBox(height: 40),

              MyTextField(prefixIcon: Icon(Icons.email), labelText: 'Email', obscureText: false, controller: _emailController,),
              SizedBox(height: 20),

              MyTextField(prefixIcon: Icon(Icons.password), labelText: 'Password', obscureText: true, controller: _passwordController,),
              SizedBox(height: 20,),

              MyButton(
                text: "Login",
                onTap: () => login(context)
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member? ',
                    style: TextStyle(fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                        'Register now',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}