// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  const TextContainer(
      {Key? key,
      required this.text,
      required this.fontSize,
      required this.alignment,
      required this.weight,
      required this.elevation,
      required this.backgroundColor})
      : super(key: key);

  final text;
  final backgroundColor;
  final fontSize;
  final alignment;
  final weight;
  final elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 15,
        left: 20,
        right: 20,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: backgroundColor,
          ),
          width: double.infinity,
          child: Text(
            text,
            style: TextStyle(
              color: foregroundColor(backgroundColor),
              fontWeight: weight,
              fontSize: fontSize.toDouble(),
              height: 1.5,
            ),
            textAlign: alignment,
          ),
          padding: const EdgeInsets.all(23),
        ),
        elevation: elevation.toDouble(),
      ),
    );
  }

  Color foregroundColor(Color c) {
    if (ThemeData.estimateBrightnessForColor(c) == Brightness.dark) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
