/* AppMuseo */

import 'package:app_museo/models/dbrecord.dart';
import 'package:app_museo/models/nfctag.dart';
import 'package:app_museo/screens/qrcodescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

// Import Firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';  // json conversion

// My Custom Widgets:
import './textdisplay.dart';
import './button.dart';

// void main() => runApp(MyApp());
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luke Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.brown,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,        
      ),
      home: MyHomePage(title: 'App Museo JFK'),
      // Define here the routes for the other app screens:
      /*
      routes: {
        '/secondscreen' : (ctx) => SecondScreen(),
      } , */
    );
  }
}


class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  // initialize Firebase connection:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  
  late List<dynamic> _itemList;  // Museum item list

  NFCtag? _nfctag = null;  // NFC tag data attribute
  String? _qrcode = null;  // QR code attribute
  
  // NFC tag data callback:
  void _setNFCID(NfcData data) {
    setState(() => _nfctag = NFCtag.fromJson(data.id, new Map<String, dynamic>.from(jsonDecode(data.content.substring(19)))) );
  }

  // QR code data callback:
  void _setQRCode(Barcode data) {
    setState(() => _qrcode = data.code );
  }

  // Firebase Realtime Database Json parsing:
  void _parseJsonItems(DataSnapshot result) {    
    // final parsedJson = json.decode(result.value);  // don't need this: json is already decoded
    // print(result.value);     // Debug Test
    // print(result.value[0]);  // Debug Test
    //return Computer.fromJson(new Map<String, dynamic>.from(result.value[index]));  // First try: works!

    _itemList = (result.value).map((i) =>
              Computer.fromJson(new Map<String, dynamic>.from(i))).toList();  
  }

  Computer getItem(int index) {
    if(index < 0 || _itemList == null  || _itemList!.length <= index) // invalid tag
    {
      print('id: '+index.toString()+', _itemList: '+(_itemList==null?'null':'ok'));
      return Computer(brand: '', id: index, description: '', name: '', year: '');
    }
    
    return _itemList![index];
  }

  @override
  Widget build(BuildContext context) {

    // NFC Stream Reader event listener:
    FlutterNfcReader.onTagDiscovered().listen((onData) {
      print(onData.id);  // debug
      print(onData.content);  // debug
      
      _setNFCID(onData);
    });


    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('An error Occurred'),
            ),
            body: Column(
              children: [
                Text("Firebase Error")            
              ],
            ),
          );        
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // Read data from database (example)          
          /*final DatabaseReference db = FirebaseDatabase.instance.reference();
          db.child('AppMuseo/').once().then((result) => print(/*result.value*/ parseJson(result, _nfctag.id)));
          */
                    
          final DatabaseReference _db = FirebaseDatabase.instance.reference();
          _db.child('AppMuseo/').once().then((result) => setState(() => _parseJsonItems(result)));
            return Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                ),
            body: Column(
              children: [
                TextDisplay(
                  text: _nfctag.toString(),
                ),
                TextDisplay(
                  text: getItem((_nfctag != null ? _nfctag!.id : -1)).name+' ('+getItem((_nfctag != null ? _nfctag!.id : -1)).year+')',
                ),
                TextDisplay(
                  text: (getItem((_nfctag != null ? _nfctag!.id : -1)).description),
                  fontsize: 15,
                  align: TextAlign.justify,
                ),
                //Button(() {}, 'click me!'),  
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QRViewExample(setQRcode: _setQRCode,),
                      ));
                  },
                  child: const Text('QR Code'),
                ),
                TextDisplay(
                  text: 'QR: '+(_qrcode != null ? _qrcode! : ''),
                ),
              ],
            ),          
            );
          }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
                appBar: AppBar(
                  title: Text('JFK Museum'),
                ),
            body: Column(
              children: [
                Center(child: CircularProgressIndicator())            
              ],
            ),
         
        );
      },
    );
  }
}