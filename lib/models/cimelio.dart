class Cimelio {
  final int id;
  final String brand;
  final String description;
  final String name;
  final String year;

  Cimelio({
    required this.id,
    required this.brand,
    required this.description,
    required this.name,
    required this.year,
  });

  // Funzione per costruire l'ogetto partendo da un JSON parsato
  factory Cimelio.fromJson(Map<String, dynamic> parsedJson) {
    return Cimelio(
      id: parsedJson['id'],
      brand: parsedJson['brand'],
      description: parsedJson['description'],
      name: parsedJson['name'],
      year: parsedJson['year'],
    );
  }
}
