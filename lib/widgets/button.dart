import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() selectHandler;
  final String buttonText;

  Button(this.selectHandler, this.buttonText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        //color: Colors.blue,
        //textColor: Colors.white,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // background
          foregroundColor: Colors.white, // foreground
        ),
        child: Text(buttonText),
        onPressed: selectHandler,
      ),
    );
  }
}
