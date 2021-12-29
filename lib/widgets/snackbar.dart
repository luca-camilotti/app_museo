import 'package:flutter/material.dart';
/*
The snackbar should be in a separate 
widget.
 */
class Snackbar extends StatelessWidget {
  final String? snackbarText;  // text to show in snackbar
  //final bool show;  // show snackbar?
  final int duration; // how many seconds
  final Function() lastJob; // reset snackbar to prevent continous showing

  Snackbar({required this.snackbarText, required this.lastJob, this.duration=3});

  @override
  Widget build(BuildContext context) {

    final snackbar = SnackBar(
      duration: Duration(seconds: duration),
      content: Text(snackbarText.toString()),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );   
    if(snackbarText!=null && snackbarText!.length > 0) {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      lastJob();
    }
    return Container(
      width: double.infinity,
      child: null,
    );
  }
}