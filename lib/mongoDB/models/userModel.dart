import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

class UserModelMongo {

  UserModelMongo({
  required this.id,
  required this.verify,
  required this.recommend,
  required this.status,
  required this.email,
  required this.password,
  required this.username,
  required this.phone,
  required this.chooseType,
  required this.nameStore,
  required this.address,
  required this.city,
  required this.bio,
  required this.imageUrl,
  required this.imageTable,
  required this.token,
  required this.favoriteCount,

  });

  final ObjectId id;
  final String verify;
  final String recommend;
  final String status;
  final String email;
  final String password;
  final String username;
  final String phone;
  final String chooseType;
  final String nameStore;
  final String address;
  final String city;
  final String bio;
  final String imageUrl;
  final String imageTable;
  final String token;
  final String favoriteCount;


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'verify': verify,
      'recommend': recommend,
      'status': status,
      'email': email,
      'password': password,
      'username': username,
      'phone': phone,
      'chooseType': chooseType,
      'nameStore': nameStore,
      'address': address,
      'city': city,
      'bio': bio,
      'imageUrl': imageUrl,
      'imageTable': imageTable,
      'token': token,
      'favoriteCount': favoriteCount,
    };
  }

  factory UserModelMongo.fromMap(Map<String, dynamic> json) {
    return UserModelMongo(
      id: json['id'],
      verify: json['verify'],
      recommend: json['recommend'],
      status: json['status'],
      email: json['email'],
      password: json['password'],
      username: json['username'],
      phone: json['phone'],
      chooseType: json['chooseType'],
      nameStore: json['nameStore'],
      address: json['address'],
      city: json['city'],
      bio: json['bio'],
      imageUrl: json['imageUrl'],
      imageTable: json['imageTable'],
      token: json['token'],
      favoriteCount: json['favoriteCount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModelMongo.fromJson(String source) => UserModelMongo.fromMap(json.decode(source));
}
