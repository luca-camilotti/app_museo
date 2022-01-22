import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as htmlParser; // to print html chars


class TextDisplay extends StatelessWidget {
  final String text;
  final double fontsize;
  final TextAlign align;  

  TextDisplay({required this.text, this.fontsize = 28, this.align = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    
    return Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: Text(htmlParser.DocumentFragment.html(text).text.toString(),
                style: TextStyle(fontSize: this.fontsize),
                textAlign: this.align,
              ),//CircularProgressIndicator(),
            );
  }
}
