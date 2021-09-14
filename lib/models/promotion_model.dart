import 'dart:convert';


class PromotionModel {
  
  String id;
  String idStore;
  String nameStore;
  String promotion;
  String price;
  String detail;
  String imagePromotion;
  
  PromotionModel({
    required this.id,
    required this.idStore,
    required this.nameStore,
    required this.promotion,
    required this.price,
    required this.detail,
    required this.imagePromotion,
  });
  

  PromotionModel copyWith({
    String? id,
    String? idStore,
    String? nameStore,
    String? promotion,
    String? price,
    String? detail,
    String? imagePromotion,
  }) {
    return PromotionModel(
      id: id ?? this.id,
      idStore: idStore ?? this.idStore,
      nameStore: nameStore ?? this.nameStore,
      promotion: promotion ?? this.promotion,
      price: price ?? this.price,
      detail: detail ?? this.detail,
      imagePromotion: imagePromotion ?? this.imagePromotion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idStore': idStore,
      'nameStore': nameStore,
      'promotion': promotion,
      'price': price,
      'detail': detail,
      'imagePromotion': imagePromotion,
    };
  }

  factory PromotionModel.fromMap(Map<String, dynamic> map) {
    return PromotionModel(
      id: map['id'],
      idStore: map['idStore'],
      nameStore: map['nameStore'],
      promotion: map['promotion'],
      price: map['price'],
      detail: map['detail'],
      imagePromotion: map['imagePromotion'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionModel.fromJson(String source) => PromotionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PromotionModel(id: $id, idStore: $idStore, nameStore: $nameStore, promotion: $promotion, price: $price, detail: $detail, imagePromotion: $imagePromotion)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PromotionModel &&
      other.id == id &&
      other.idStore == idStore &&
      other.nameStore == nameStore &&
      other.promotion == promotion &&
      other.price == price &&
      other.detail == detail &&
      other.imagePromotion == imagePromotion;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idStore.hashCode ^
      nameStore.hashCode ^
      promotion.hashCode ^
      price.hashCode ^
      detail.hashCode ^
      imagePromotion.hashCode;
  }
}
