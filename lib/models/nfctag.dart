// Model for NFC Tag content

class NFCtag {
  final String tagid;
  final int id;
  

  NFCtag({
    required this.tagid,
    required this.id,    
  });

  factory NFCtag.fromJson(String tagid, Map<String, dynamic> parsedJson){
    return NFCtag(
      tagid: tagid,
      id: parsedJson['id'],      
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Tag "+this.tagid+": "+this.id.toString();
  }
}