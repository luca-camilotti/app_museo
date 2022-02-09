// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import '/widgets/TextContainer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class CimelioScreen extends StatelessWidget {
  const CimelioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inizializzo l'escaper per i caratteri HTML
    var unescape = HtmlUnescape();

    // Struttura dei parametri passati allo Screen
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Ottengo dalla struttura il parametro "cimelio" che non è altro che il Cimelio collegato al QR
    final cimelio = routeArgs["cimelio"];

    final String brand = cimelio.brand;

    // La descrizione può contenere caratteri HTML e va fatto un escape
    final String description = unescape.convert(cimelio.description);

    final String name = cimelio.name;
    final String year = cimelio.year;

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
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: <Widget>[
                    TextContainer(
                      text: name,
                      fontSize: 24,
                      weight: FontWeight.bold,
                      backgroundColor: const Color(0xffEF5347),
                      alignment: TextAlign.center,
                      elevation: 3,
                    ),
                    TextContainer(
                      text: "Marca: " + brand,
                      fontSize: 18,
                      weight: FontWeight.normal,
                      backgroundColor: Colors.white,
                      alignment: TextAlign.center,
                      elevation: 2,
                    ),
                    TextContainer(
                      text: "Anno di produzione: " + year,
                      fontSize: 18,
                      weight: FontWeight.normal,
                      backgroundColor: Colors.white,
                      alignment: TextAlign.center,
                      elevation: 2,
                    ),
                    TextContainer(
                      text: description,
                      fontSize: 18,
                      weight: FontWeight.normal,
                      backgroundColor: Colors.white,
                      alignment: TextAlign.center,
                      elevation: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
