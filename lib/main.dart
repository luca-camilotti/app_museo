// 1) Create a new Flutter App (in this project) and output an AppBar and some text
// below it
// 2) Add a button which changes the text (to any other text of your choice)
// 3) Split the app into three widgets: App, TextControl & Text


import 'package:app_museo/models/dbrecord.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';

import 'dart:convert';  // json conversion

import './textdisplay.dart';
import './button.dart';

// void main() => runApp(MyApp());
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  
  var _index = 0;

  var _displayMessages = [
      'Hello World',
      'Ciao Mondo',
      'Hallo Welt',
      'Bonjour le Monde',
      'Hola Mundo',
      'Saluton mondo',
    ];

  void _changeMessage() {
    setState(() {
      if(_index >= _displayMessages.length -1) 
        _index = 0;
      
      else
        _index += 1;
      
    });
    print(_index);
  }

  // Firebase Realtime Database Json parsing:
  Computer parseJson(DataSnapshot result, int index) {    
    //final parsedJson = json.decode(result.value);  // don't need this: json is already decoded
    // final parsed = result.value[0];
    // print(result.value);
    // print(result.value[0]);
    return Computer.fromJson(new Map<String, dynamic>.from(result.value[index]));
    /*
    final myComputerList=(result.value).map((i) =>
              Computer.fromJson(i)).toList();
    return myComputerList.elementAt(index);
    */
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: Text('An error Occurred'),
                ),
            body: Column(
              children: [
                Text("Firebase Error")            
              ],
            ),
          ),
        );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // Read data from database (example)          
          final DatabaseReference db = FirebaseDatabase.instance.reference();
          db.child('AppMuseo/').once().then((result) => print(/*result.value*/ parseJson(result, _index)));
          
          
            return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: Text('JFK Museum'),
                ),
            body: Column(
              children: [
                TextDisplay(
                  _displayMessages[_index],
                ),
                Button(_changeMessage, 'click me!'),            
              ],
            ),
          ),
        );
          }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: Text('JFK Museum'),
                ),
            body: Column(
              children: [
                Center(child: CircularProgressIndicator())            
              ],
            ),
          ),
        );
      },
    );
  }
}