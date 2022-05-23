// ignore_for_file: file_names

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';  // NFC plugin
import 'package:nfc_manager/nfc_manager.dart'; // New NFC plugin (23-05-2022)
import 'package:flutter/material.dart';
import '/models/nfctag.dart';
import '/models/cimelio.dart';
import '/widgets/TextContainer.dart';
import 'package:url_launcher/url_launcher.dart';
import '/utils/auth.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // Credenziali Firebase Auth (necessario per accedere al db con i cimeli)
  final useremail = "pippo.appmuseo@jfkennedy.gov.yes";
  final userpwd = "itiskennedy2022";


  int _item = -1; 
  NFCtag? _nfctag = null;  // NFC tag data attribute
  String? _qrcode = null;  // QR code attribute
  
  // NFC tag data callback - deprecated:
  /*
  void _setNFCID(NfcData data) {
    setState(() {
      _nfctag = NFCtag.fromJson(data.id, new Map<String, dynamic>.from(jsonDecode(data.content.substring(19))));
      if(_nfctag!.id >= 0) {
        _item = _nfctag!.id;
      }
      var message = 'NFC tag item: ${_nfctag!.id}';
      showSnackbar(message, 3);
     });
  }*/

  // Show info on NFC tag:
  void _showInfoNFC(/*NfcData*/ Map<String, dynamic> data) {
    // _nfctag = NFCtag.fromJson(data.id, new Map<String, dynamic>.from(jsonDecode(data.content.substring(19))));
    _nfctag = NFCtag.fromJson(data['id'], new Map<String, dynamic>.from(jsonDecode(data['content'].substring(19))));
    if(_nfctag != null && _nfctag!.id >= 0) {
      _item = _nfctag!.id;
      var cimelio;
      var id = _nfctag!.id;
        for (int i = 0; i < cimeli.length; i++) {
          if (cimeli[i].id == id) {
            cimelio = cimeli[i];
          }
        }
        if(cimelio!=null) {
            Navigator.of(context).pushNamed("/result", arguments: {
              "cimelio": cimelio,
            });
            // dispose();
        }
        else {
          // showSnackbar("NFCtag id: "+id.toString(), 3);
        }
    }
    var message = 'NFC tag item: ${_nfctag!.id}';
    showSnackbar(message, 3);
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
  List<Cimelio> _parseJsonItems(DataSnapshot result) {    
    // final parsedJson = json.decode(result.value);  // don't need this: json is already decoded
    // print(result.value);     // Debug Test
    // print(result.value[0]);  // Debug Test
    //return Computer.fromJson(new Map<String, dynamic>.from(result.value[index]));  // First try: works!

    print('_parseJsonItems(): '+result.value.toString());  // debug   
     

    return (result.value).map<Cimelio>((i) =>
              Cimelio.fromJson(new Map<String, dynamic>.from(i))).toList();  
  }

  @override
  Widget build(BuildContext context) {

    // NFC Stream Reader event listener:
    /*
    FlutterNfcReader.onTagDiscovered().listen((onData) {
      print(onData.id);  // debug
      print(onData.content);  // debug
      
      _showInfoNFC(onData);
    });
    */

    NfcManager.instance.isAvailable().then((value) {
      print('NFC reader ready..');
      
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          // Do something with an NfcTag instance:
          print(tag.data['id']);  // debug
          print(tag.data['content']);  // debug
          _showInfoNFC(tag.data);
          // result.value = tag.data;
        },
      );
    } );


    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('An error Occurred'),
            ),
            body: Column(
              children: const <Widget>[
                Text("Firebase Error"),
              ],
            ),
          );
        } else {
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            final DatabaseReference _db = FirebaseDatabase.instance.reference();

            final authHandler = Auth();
            authHandler.handleSignInEmail(useremail, userpwd).then((User user) {
              _db.child('AppMuseo/' + user.uid + '/').once().then((result) {
                print('(HomeScreen) Firebase Realtime DB fetching: '+result.value.toString());
                cimeli = _parseJsonItems(result);
                print("(HomeScreen) cimeli.length: "+cimeli.length.toString()); 
                /*
                for (var obj in jsonDecode(jsonEncode(result.snapshot.value))) {
                  Cimelio cimelio = Cimelio.fromJson(obj);
                  cimeli.add(cimelio);
                } */
              });
            }).catchError((e) {});

            return Scaffold(
              backgroundColor: const Color(0xffEDEDED),
              appBar: AppBar(
                title: const Text("JFK Muse"),
                backgroundColor: const Color(0xffEF5347),
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          launch(shareUrl);
                        },
                        child: Icon(
                          Icons.share,
                          color: Colors.white.withOpacity(0.75),
                          size: 26.0,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/help');
                      },
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white.withOpacity(0.75),
                        size: 26.0,
                      ),
                    ),
                  ),
                ],
              ),
              body: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      const TextContainer(
                        text: "Benvenuto al Kennedy 🖖",
                        fontSize: 24,
                        weight: FontWeight.bold,
                        backgroundColor: Color(0xffEF5347),
                        alignment: TextAlign.center,
                        elevation: 3,
                      ),
                      const TextContainer(
                        text:
                            "Con quest’app potrai esplorare il nostro museo dell’informatica interagendo direttamente con questi cimeli vintage!",
                        fontSize: 18,
                        weight: FontWeight.normal,
                        backgroundColor: Colors.white,
                        alignment: TextAlign.center,
                        elevation: 2,
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 18),
                            children: [
                              const TextSpan(
                                text:
                                    "Per consultare le istruzioni d’uso tocca il tasto ",
                              ),
                              WidgetSpan(
                                child: Icon(Icons.info_outline,
                                    size: 18,
                                    color: Colors.black.withOpacity(0.4)),
                              ),
                              const TextSpan(
                                text: " in alto a destra.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: const Color(0xffEF5347),
                child: const Icon(Icons.qr_code_rounded,
                    size: 28, color: Colors.white),
                onPressed: ()  {
                  // Stop Session
                  // NfcManager.instance.stopSession();
                  Navigator.of(context).pushNamed('/scan');},
              ),
            );
          } else {
            return Container();
          }
        }
      },
    );
  }
}
