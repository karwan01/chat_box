import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({Key? key, this.buttonName, this.onPressed}) : super(key: key);
  String? buttonName;
  VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        buttonName!,
        style: TextStyle(fontSize: 20),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 20),
        elevation: 2,
        shadowColor: Colors.teal.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
