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
  final String favoriteCount;

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
    required this.favoriteCount,
  });

  UserModel copyWith({
    String? id,
    String? verify,
    String? recommend,
    String? status,
    String? email,
    String? password,
    String? username,
    String? phone,
    String? chooseType,
    String? nameStore,
    String? address,
    String? city,
    String? bio,
    String? imageUrl,
    String? imageTable,
    String? token,
    String? favoriteCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      verify: verify ?? this.verify,
      recommend: recommend ?? this.recommend,
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      chooseType: chooseType ?? this.chooseType,
      nameStore: nameStore ?? this.nameStore,
      address: address ?? this.address,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      imageTable: imageTable ?? this.imageTable,
      token: token ?? this.token,
      favoriteCount: favoriteCount ?? this.favoriteCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Verify': verify,
      'Recommend': recommend,
      'Status': status,
      'Email': email,
      'Password': password,
      'Username': username,
      'Phone': phone,
      'ChooseType': chooseType,
      'NameStore': nameStore,
      'Address': address,
      'City': city,
      'Bio': bio,
      'ImageUrl': imageUrl,
      'ImageTable': imageTable,
      'Token': token,
      'FavoriteCount': favoriteCount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      verify: map['verify'],
      recommend: map['recommend'],
      status: map['status'],
      email: map['email'],
      password: map['password'],
      username: map['username'],
      phone: map['phone'],
      chooseType: map['chooseType'],
      nameStore: map['nameStore'],
      address: map['address'],
      city: map['city'],
      bio: map['bio'],
      imageUrl: map['imageUrl'],
      imageTable: map['imageTable'],
      token: map['token'],
      favoriteCount: map['favoriteCount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, verify: $verify, recommend: $recommend, status: $status, email: $email, password: $password, username: $username, phone: $phone, chooseType: $chooseType, nameStore: $nameStore, address: $address, city: $city, bio: $bio, imageUrl: $imageUrl, imageTable: $imageTable, token: $token, favoriteCount: $favoriteCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.verify == verify &&
      other.recommend == recommend &&
      other.status == status &&
      other.email == email &&
      other.password == password &&
      other.username == username &&
      other.phone == phone &&
      other.chooseType == chooseType &&
      other.nameStore == nameStore &&
      other.address == address &&
      other.city == city &&
      other.bio == bio &&
      other.imageUrl == imageUrl &&
      other.imageTable == imageTable &&
      other.token == token &&
      other.favoriteCount == favoriteCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      verify.hashCode ^
      recommend.hashCode ^
      status.hashCode ^
      email.hashCode ^
      password.hashCode ^
      username.hashCode ^
      phone.hashCode ^
      chooseType.hashCode ^
      nameStore.hashCode ^
      address.hashCode ^
      city.hashCode ^
      bio.hashCode ^
      imageUrl.hashCode ^
      imageTable.hashCode ^
      token.hashCode ^
      favoriteCount.hashCode;
  }

  contains(String value) {}
}
