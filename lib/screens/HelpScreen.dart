// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:muse/widgets/TextContainer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                TextContainer(
                  text: "Guida all'uso 💡",
                  fontSize: 24,
                  weight: FontWeight.bold,
                  backgroundColor: Color(0xffEF5347),
                  alignment: TextAlign.center,
                  elevation: 3,
                ),
                TextContainer(
                  text:
                      "Per ottenere le informazioni di un elemento del museo è possibile proseguire in due modi:\n\n 1) Usando un codice QR\n 2) Usando il sensore NFC",
                  fontSize: 18,
                  weight: FontWeight.normal,
                  backgroundColor: Colors.white,
                  alignment: TextAlign.center,
                  elevation: 2,
                ),
                TextContainer(
                  text: "Codici QR 📷",
                  fontSize: 24,
                  weight: FontWeight.bold,
                  backgroundColor: Color(0xffEF5347),
                  alignment: TextAlign.center,
                  elevation: 3,
                ),
                TextContainer(
                  text:
                      "Per questa opzione è sufficiente toccare il tasto tondo rosso in basso a destra nel menu principale e inquadrare il codice QR nella targetta del cimelio.",
                  fontSize: 18,
                  weight: FontWeight.normal,
                  backgroundColor: Colors.white,
                  alignment: TextAlign.center,
                  elevation: 2,
                ),
                TextContainer(
                  text: "Sensore NFC 🏷",
                  fontSize: 24,
                  weight: FontWeight.bold,
                  backgroundColor: Color(0xffEF5347),
                  alignment: TextAlign.center,
                  elevation: 3,
                ),
                TextContainer(
                  text:
                      "Il sensore NFC non è disponibile su tutti i dispositivi, nel caso in cui sia presente è possibile attivarlo accedendo alla tendina delle notifiche. (solo su Android è necessario) Dopodichè è sufficiente avvicinare il cellulare alla targhetta del cimelio.",
                  fontSize: 18,
                  weight: FontWeight.normal,
                  backgroundColor: Colors.white,
                  alignment: TextAlign.center,
                  elevation: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
