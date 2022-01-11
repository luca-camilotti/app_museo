/* AppMuseo */

import 'package:app_museo/utils/auth.dart';
import 'package:flutter/material.dart';
// Models:
import 'package:app_museo/models/dbrecord.dart';
import 'package:app_museo/models/nfctag.dart';
// Screens:
import 'package:app_museo/screens/qrcodescreen.dart';
// Widgets:
import 'package:app_museo/widgets/textdisplay.dart';

// NFC plugin:
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

// Firebase_core plugin:
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// Firebase authentication:
import 'package:firebase_auth/firebase_auth.dart';

// Json stuff:
import 'dart:convert';  // json conversion

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
  
  // Firebase auth
  final useremail = "pippo.appmuseo@jfkennedy.gov.yes";
  final userpwd = "itiskennedy2022";
  

  /*
  authHandler.handleSignInEmail(emailController.text, passwordController.text)
    .then((FirebaseUser user) {
         Navigator.push(context, new MaterialPageRoute(builder: (context) => new HomePage()));
   }).catchError((e) => print(e));
  */

  late List<dynamic> itemList = [];  // Museum item list

  int _item = -1; 

  NFCtag? _nfctag = null;  // NFC tag data attribute
  String? _qrcode = null;  // QR code attribute
  
  // NFC tag data callback:
  void _setNFCID(NfcData data) {
    setState(() {
      _nfctag = NFCtag.fromJson(data.id, new Map<String, dynamic>.from(jsonDecode(data.content.substring(19))));
      if(_nfctag!.id >= 0) {
        _item = _nfctag!.id;
      }
      var message = 'NFC tag item: ${_nfctag!.id}';
      showSnackbar(message, 3);
     });
  }

  // QR code data callback:
  void _setQRCode(Barcode data) {
    setState(() { 
      _qrcode = data.code;
      String message = 'QR Code Error: '+data.code.toString();
      String code = data.code!=null ? data.code!.substring(data.code!.length-2) : ''; 
      int val = int.tryParse(code) ?? -1;
      if(val >= 0) {
        message = 'QR code item: $val';
        _item = val;
      }
      showSnackbar(message, 3);      
     });
  }

  // Show a snackbar: 
  void showSnackbar(String? text, int duration) {
    final String message = (text==null ? 'invalid QR: '+text.toString() : text.toString());
    final snackbar = SnackBar(
      duration: Duration(seconds: duration),
      content: Text(message),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );   
    if(message!=null && message.length > 0) {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);      
    }
  }

  // Firebase Realtime Database Json parsing:
  List<dynamic> _parseJsonItems(DataSnapshot result) {    
    // final parsedJson = json.decode(result.value);  // don't need this: json is already decoded
    // print(result.value);     // Debug Test
    // print(result.value[0]);  // Debug Test
    //return Computer.fromJson(new Map<String, dynamic>.from(result.value[index]));  // First try: works!

    print('_parseJsonItems(): '+result.value.toString());  // debug     

    return (result.value).map((i) =>
              Computer.fromJson(new Map<String, dynamic>.from(i))).toList();  
  }

  Computer getItem(int index, List<dynamic> itemList) {
    print('id: '+index.toString()+', itemList: '+(itemList==null?'null':'ok'));
    print('itemList.length: '+itemList!.length.toString());
    /*
    if(index < 0 || itemList == null  || itemList!.length <= index) // invalid tag
    {      
      //showSnackbar('Item with id $index not found', 4);
      return Computer(brand: '', id: index, description: '', name: '', year: '');
    } */
    for (Computer item in itemList ) {
      if(index == item.id)
        return item;
    }
    // return itemList![index];
    //showSnackbar('Item with id $index not found', 4);
    return Computer(brand: '', id: index, description: '', name: '', year: '');
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
          
          final authHandler = new Auth();
          authHandler.handleSignInEmail(useremail, userpwd)
              .then((User user) {
                _db.child('AppMuseo/').once().then((result)  {
                  print('Firebase Realtime DB fetching: '+result.value.toString());
                  itemList = _parseJsonItems(result);
                });
              }).catchError((e) => print("Unable to login to Firebase!"));
                    
          return Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                ),
            body: Column(
              children: [
                // TextDisplay(text: _nfctag.toString(),),  // for debug
                // TextDisplay(text: 'QR: '+(_qrcode != null ? _qrcode! : ''),),  // for debug
                TextDisplay(
                  text: (getItem(_item, itemList).name!=null && getItem(_item, itemList).name.length>0) ? getItem(_item, itemList).name+' ('+getItem(_item, itemList).year+')':'Scan NFC Tag',
                ),
                TextDisplay(
                  text: (getItem(_item, itemList).description),
                  fontsize: 15,
                  align: TextAlign.justify,
                ),
                //Button(() {}, 'click me!'),  
                /*
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QRViewExample(setQRcode: _setQRCode,),
                      ));
                  },
                  child: const Text('QR Code'),
                ), */
                
                // Snackbar(snackbarText: _snackbarText, duration: 4, lastJob: _resetSnackbar,),
              ],
            ),          
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRViewExample(setQRcode: _setQRCode,)),
                );
                /*
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QRViewExample(setQRcode: _setQRCode,),
                  )); */
                },
              tooltip: 'Scan QR code',
              child: Icon(Icons.qr_code),
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