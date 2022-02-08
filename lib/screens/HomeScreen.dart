// ignore_for_file: file_names

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:muse/models/cimelio.dart';
import 'package:muse/widgets/TextContainer.dart';
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

  @override
  Widget build(BuildContext context) {
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
            final DatabaseReference _db = FirebaseDatabase.instance.ref();

            final authHandler = Auth();
            authHandler.handleSignInEmail(useremail, userpwd).then((User user) {
              _db.child('AppMuseo/' + user.uid + '/').once().then((result) {
                for (var obj in jsonDecode(jsonEncode(result.snapshot.value))) {
                  Cimelio cimelio = Cimelio.fromJson(obj);
                  cimeli.add(cimelio);
                }
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
                onPressed: () => {Navigator.of(context).pushNamed('/scan')},
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
