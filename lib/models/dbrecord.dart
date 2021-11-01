class Computer {
  final int id;
  final String brand;
  final String description;
  final String name;
  final String year;

  Computer({
    this.id,
    this.brand,
    this.description,
    this.name,
    this.year
  });

  factory Computer.fromJson(Map<String, dynamic> parsedJson){
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
    return this.brand+" "+this.name+" "+this.year;
  }
}