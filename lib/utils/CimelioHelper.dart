import 'package:app_museo/models/cimelio.dart';
import '../main.dart';
import 'dart:core';

class CimelioHelper {
  static Cimelio? getScannedCimelio(int cimelioID) {
    Cimelio? cimelio;
    for (int i = 0; i < cimeli.length; i++) {
      if (cimeli[i].id == cimelioID) {
        cimelio = cimeli[i];
      }
    }
  return cimelio;
  }
}