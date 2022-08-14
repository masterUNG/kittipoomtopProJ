import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FavoriteModel {
  final String id;
  final String idBuyer;
  final String idStore;
  FavoriteModel({
    required this.id,
    required this.idBuyer,
    required this.idStore,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idBuyer': idBuyer,
      'idStore': idStore,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: (map['id'] ?? '') as String,
      idBuyer: (map['idBuyer'] ?? '') as String,
      idStore: (map['idStore'] ?? '') as String,
    );
  }

  factory FavoriteModel.fromJson(String source) => FavoriteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
