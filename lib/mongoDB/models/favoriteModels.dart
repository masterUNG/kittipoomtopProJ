import 'dart:convert';

class FavModels {
  
  String idStore;
  String nameStore;
  String listIdUser;
  FavModels({
    required this.idStore,
    required this.nameStore,
    required this.listIdUser,
  });

  FavModels copyWith({
    String? idStore,
    String? nameStore,
    String? listIdUser,
  }) {
    return FavModels(
      idStore: idStore ?? this.idStore,
      nameStore: nameStore ?? this.nameStore,
      listIdUser: listIdUser ?? this.listIdUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idStore': idStore,
      'nameStore': nameStore,
      'listIdUser': listIdUser,
    };
  }

  factory FavModels.fromMap(Map<String, dynamic> map) {
    return FavModels(
      idStore: map['idStore'] ?? '',
      nameStore: map['nameStore'] ?? '',
      listIdUser: map['listIdUser'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FavModels.fromJson(String source) => FavModels.fromMap(json.decode(source));

  @override
  String toString() => 'FavModels(idStore: $idStore, nameStore: $nameStore, listIdUser: $listIdUser)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FavModels &&
      other.idStore == idStore &&
      other.nameStore == nameStore &&
      other.listIdUser == listIdUser;
  }

  @override
  int get hashCode => idStore.hashCode ^ nameStore.hashCode ^ listIdUser.hashCode;
}
