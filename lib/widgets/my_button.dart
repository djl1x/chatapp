import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;

  final void Function()? onTap;

  MyButton({
    super.key, 
    required this.text, required this.onTap});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        child: Text(text),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all()
        ),
      ),
    );
  }
}