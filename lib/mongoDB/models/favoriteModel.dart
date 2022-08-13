import 'dart:convert';

class FavModelMongo {

  FavModelMongo({
  
  required this.idStore,
  required this.nameStore,
  required this.listIdUser,
  
  });

  final String idStore;
  final String nameStore;
  final String listIdUser;
 
  Map<String, dynamic> toMap() {
    return {
      
      'idStore': idStore,
      'nameStore': nameStore,
      'listIdUser': listIdUser,
      
    };
  }

  factory FavModelMongo.fromMap(Map<String, dynamic> json) {
    return FavModelMongo(
     
      idStore: json['idStore'],
      nameStore: json['nameStore'],
      listIdUser: json['listIdUser'],
      
      
    );
  }

  String toJson() => json.encode(toMap());

  factory FavModelMongo.fromJson(String source) => FavModelMongo.fromMap(json.decode(source));
}
