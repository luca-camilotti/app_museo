import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:typed_data'; // Uint8List
// Charset Converter:
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/services.dart';

class TextDisplay extends StatelessWidget {
  final String text;
  final double fontsize;
  final TextAlign align;
  

  TextDisplay({required this.text, this.fontsize = 28, this.align = TextAlign.center});

  // Decode ANSI Charset:
  Future<String> _charsetConvert() async {   
    var decoded;
    /*
    try {
      List<String> charsets = await CharsetConverter.availableCharsets();
      print('charset list : '+charsets!.toString());
    } on PlatformException {
      print('charset error!');
    }
    
    // List<int> content = text.split('').map(int.parse).toList();
    List<int> content = utf8.encode(text);
    print('char list : '+content!.toString());
    
    try {
      decoded = await CharsetConverter.decode("windows1250", Uint8List.fromList(content));
      print('decoded: '+decoded!);      
    } on PlatformException {
      print('decode error!');
    } */

    decoded = text.replaceAll('&agrave;', 'à').replaceAll('&egrave;', 'è')
    .replaceAll('&igrave;', 'ì').replaceAll('&ograve;', 'ò').replaceAll('&ugrave;', 'ù')
    .replaceAll('&Agrave;', 'À').replaceAll('&Egrave;', 'È')
    .replaceAll('&Igrave;', 'Ì').replaceAll('&Ograve;', 'Ò').replaceAll('&Ugrave;', 'Ù')
    .replaceAll('&aacute;', 'á').replaceAll('&eacute;', 'é')
    .replaceAll('&iacute;', 'í').replaceAll('&oacute;', 'ó').replaceAll('&uacute;', 'ú');
    return Future.value(decoded!=null ? decoded : 'decoding error');
  }

  Future<String> _downloadData() async{
    //   var response =  await http.get('https://getProjectList');    
    return Future.value("Data download successfully"); // return your response
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<String>(
        future: _charsetConvert(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: Text(
              '${snapshot.data}',
              style: TextStyle(fontSize: this.fontsize),
              textAlign: this.align,
              ),
            );
          }
          else 
            return Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: Text('No data..',
              style: TextStyle(fontSize: this.fontsize),
              textAlign: this.align,
              ),//CircularProgressIndicator(),
            );
        }
    );
  }
}
