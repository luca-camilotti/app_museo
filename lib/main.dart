import 'package:flutter/material.dart';
import 'models/cimelio.dart';
import 'screens/CimelioScreen.dart';
import 'screens/HelpScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/ScanScreen.dart';

void main() {
  runApp(const Muse());
}

// Link all'app del kennedy sullo store Android
String shareUrl =
    "https://play.google.com/store/apps/details?id=com.jfkennedy.app_museo";

// Array che mantiene tutti i Cimeli del museo (ottenuti da Firebase)
List<Cimelio> cimeli = [];

class Muse extends StatelessWidget {
  const Muse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xffEF5347),
        ),
      ),

      // Percorsi di route
      routes: {
        "/help": (ctx) => const HelpScreen(),
        "/scan": (ctx) => const ScanScreen(),
        "/result": (ctx) => const CimelioScreen(),
      },
    );
  }
}
