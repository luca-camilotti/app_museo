// Model for Firebase Realtime database content
import 'package:charset_converter/charset_converter.dart';

class Computer {
  final int id;
  final String brand;
  final String description;
  final String name;
  final String year;

  Computer({
    required this.id,
    required this.brand,
    required this.description,
    required this.name,
    required this.year
  });

  factory Computer.fromJson(Map<String, dynamic> parsedJson) {    
    return Computer(
      id: parsedJson['id'],
      brand : parsedJson ['brand'],
      description : parsedJson ['description'],
      name : parsedJson['name'],
      year : parsedJson['year'],
      
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return "item "+this.id.toString()+": "+this.brand+" "+this.name+" "+this.year;
  }
}