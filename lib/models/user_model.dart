// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
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
  final String idShops;
  UserModel({
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
    required this.idShops,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      'idShops': idShops,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: (map['id'] ?? '') as String,
      verify: (map['verify'] ?? '') as String,
      recommend: (map['recommend'] ?? '') as String,
      status: (map['status'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      username: (map['username'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      chooseType: (map['chooseType'] ?? '') as String,
      nameStore: (map['nameStore'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      city: (map['city'] ?? '') as String,
      bio: (map['bio'] ?? '') as String,
      imageUrl: (map['imageUrl'] ?? '') as String,
      imageTable: (map['imageTable'] ?? '') as String,
      token: (map['token'] ?? '') as String,
      idShops: (map['idShops'] ?? '') as String,
    );
  }

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
