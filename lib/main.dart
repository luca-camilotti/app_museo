/* AppMuseo */

import 'package:app_museo/models/dbrecord.dart';
import 'package:app_museo/models/nfctag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

// Import Firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';  // json conversion

// My Custom Widgets:
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
  // initialize Firebase connection:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  DatabaseReference _db;
  DataSnapshot _dbdata;
  NFCtag _nfctag = null;  // NFC tag data attribute
  
  // Get NFC tag data:
  void setNFCID(NfcData data) {
    setState(() => _nfctag = NFCtag.fromJson(data.id, new Map<String, dynamic>.from(jsonDecode(data.content.substring(19)))) );
  }

  // Firebase Realtime Database Json parsing:
  Computer parseJson(DataSnapshot result, int index) {    
    // final parsedJson = json.decode(result.value);  // don't need this: json is already decoded
    // print(result.value);     // Debug Test
    // print(result.value[0]);  // Debug Test
    //return Computer.fromJson(new Map<String, dynamic>.from(result.value[index]));  // First try: works!

    final myComputerList=(result.value).map((i) =>
              Computer.fromJson(new Map<String, dynamic>.from(i))).toList();
    return myComputerList[index];    
  }

  @override
  Widget build(BuildContext context) {

    // NFC Stream Reader event listener:
    FlutterNfcReader.onTagDiscovered().listen((onData) {
      print(onData.id);  // debug
      print(onData.content);  // debug
      
      setNFCID(onData);
    });


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
          /*final DatabaseReference db = FirebaseDatabase.instance.reference();
          db.child('AppMuseo/').once().then((result) => print(/*result.value*/ parseJson(result, _nfctag.id)));
          */
          _db = FirebaseDatabase.instance.reference();
          _db.child('AppMuseo/').once().then((result) => setState(() => _dbdata = result));
            return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: Text('JFK Museum'),
                ),
            body: Column(
              children: [
                TextDisplay(
                  text: _nfctag.toString(),
                ),
                TextDisplay(
                  text: parseJson(_dbdata, _nfctag.id).name+' ('+parseJson(_dbdata, _nfctag.id).year+')',
                ),
                TextDisplay(
                  text: (parseJson(_dbdata, _nfctag.id).description),
                  fontsize: 15,
                  align: TextAlign.justify,
                ),
                Button(() {}, 'click me!'),            
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