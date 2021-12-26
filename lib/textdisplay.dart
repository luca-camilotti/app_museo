import 'package:flutter/material.dart';

class TextDisplay extends StatelessWidget {
  final String text;
  final double fontsize;
  final TextAlign align;

  TextDisplay({this.text, this.fontsize = 28, this.align = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(fontSize: this.fontsize),
        textAlign: this.align,
      ),
    );
  }
}
