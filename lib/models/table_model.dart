import 'dart:convert';

class TableModel {
  String id;
  String idStore;
  String nameStore;
  String numberTable;
  String bookingDate;
  TableModel({
    required this.id,
    required this.idStore,
    required this.nameStore,
    required this.numberTable,
    required this.bookingDate,
  });

  TableModel copyWith({
    String? id,
    String? idStore,
    String? nameStore,
    String? numberTable,
    String? bookingDate,
  }) {
    return TableModel(
      id: id ?? this.id,
      idStore: idStore ?? this.idStore,
      nameStore: nameStore ?? this.nameStore,
      numberTable: numberTable ?? this.numberTable,
      bookingDate: bookingDate ?? this.bookingDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idStore': idStore,
      'nameStore': nameStore,
      'numberTable': numberTable,
      'bookingDate': bookingDate,
    };
  }

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map['id'],
      idStore: map['idStore'],
      nameStore: map['nameStore'],
      numberTable: map['numberTable'],
      bookingDate: map['bookingDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TableModel.fromJson(String source) => TableModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TableModelStore(id: $id, idStore: $idStore, nameStore: $nameStore, numberTable: $numberTable, bookingDate: $bookingDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TableModel &&
      other.id == id &&
      other.idStore == idStore &&
      other.nameStore == nameStore &&
      other.numberTable == numberTable &&
      other.bookingDate == bookingDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idStore.hashCode ^
      nameStore.hashCode ^
      numberTable.hashCode ^
      bookingDate.hashCode;
  }
}

  