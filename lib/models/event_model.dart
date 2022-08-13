import 'dart:convert';

class EventModel {
  String id;
  String idStore;
  String nameStore;
  String event;
  String price;
  String detail;
  String date;
  String imageEvent;
  EventModel({
    required this.id,
    required this.idStore,
    required this.nameStore,
    required this.event,
    required this.price,
    required this.detail,
    required this.date,
    required this.imageEvent,
  });

  EventModel copyWith({
    String? id,
    String? idStore,
    String? nameStore,
    String? event,
    String? price,
    String? detail,
    String? date,
    String? imageEvent,
  }) {
    return EventModel(
      id: id ?? this.id,
      idStore: idStore ?? this.idStore,
      nameStore: nameStore ?? this.nameStore,
      event: event ?? this.event,
      price: price ?? this.price,
      detail: detail ?? this.detail,
      date: date ?? this.date,
      imageEvent: imageEvent ?? this.imageEvent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idStore': idStore,
      'nameStore': nameStore,
      'event': event,
      'price': price,
      'detail': detail,
      'date': date,
      'imageEvent': imageEvent,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      idStore: map['idStore'] ?? '',
      nameStore: map['nameStore'] ?? '',
      event: map['event'] ?? '',
      price: map['price'] ?? '',
      detail: map['detail'] ?? '',
      date: map['date'] ?? '',
      imageEvent: map['imageEvent'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(id: $id, idStore: $idStore, nameStore: $nameStore, event: $event, price: $price, detail: $detail, date: $date, imageEvent: $imageEvent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is EventModel &&
      other.id == id &&
      other.idStore == idStore &&
      other.nameStore == nameStore &&
      other.event == event &&
      other.price == price &&
      other.detail == detail &&
      other.date == date &&
      other.imageEvent == imageEvent;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idStore.hashCode ^
      nameStore.hashCode ^
      event.hashCode ^
      price.hashCode ^
      detail.hashCode ^
      date.hashCode ^
      imageEvent.hashCode;
  }
}
