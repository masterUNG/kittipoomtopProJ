import 'dart:convert';

class TableModelUser {
  String id;
  String checkIn;
  String idStore;
  String nameStore;
  String numberTable;
  String username;
  String idUser;
  String dateTime;
  String bookingDate;
  String status;
  String phone;
  TableModelUser({
    required this.id,
    required this.checkIn,
    required this.idStore,
    required this.nameStore,
    required this.numberTable,
    required this.username,
    required this.idUser,
    required this.dateTime,
    required this.bookingDate,
    required this.status,
    required this.phone,
  });

  TableModelUser copyWith({
    String? id,
    String? checkIn,
    String? idStore,
    String? nameStore,
    String? numberTable,
    String? username,
    String? idUser,
    String? dateTime,
    String? bookingDate,
    String? status,
    String? phone,
  }) {
    return TableModelUser(
      id: id ?? this.id,
      checkIn: checkIn ?? this.checkIn,
      idStore: idStore ?? this.idStore,
      nameStore: nameStore ?? this.nameStore,
      numberTable: numberTable ?? this.numberTable,
      username: username ?? this.username,
      idUser: idUser ?? this.idUser,
      dateTime: dateTime ?? this.dateTime,
      bookingDate: bookingDate ?? this.bookingDate,
      status: status ?? this.status,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'checkIn': checkIn,
      'idStore': idStore,
      'nameStore': nameStore,
      'numberTable': numberTable,
      'username': username,
      'idUser': idUser,
      'dateTime': dateTime,
      'bookingDate': bookingDate,
      'status': status,
      'phone': phone,
    };
  }

  factory TableModelUser.fromMap(Map<String, dynamic> map) {
    return TableModelUser(
      id: map['id'] ?? '',
      checkIn: map['checkIn'] ?? '',
      idStore: map['idStore'] ?? '',
      nameStore: map['nameStore'] ?? '',
      numberTable: map['numberTable'] ?? '',
      username: map['username'] ?? '',
      idUser: map['idUser'] ?? '',
      dateTime: map['dateTime'] ?? '',
      bookingDate: map['bookingDate'] ?? '',
      status: map['status'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TableModelUser.fromJson(String source) => TableModelUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TableModelUser(id: $id, checkIn: $checkIn, idStore: $idStore, nameStore: $nameStore, numberTable: $numberTable, username: $username, idUser: $idUser, dateTime: $dateTime, bookingDate: $bookingDate, status: $status, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TableModelUser &&
      other.id == id &&
      other.checkIn == checkIn &&
      other.idStore == idStore &&
      other.nameStore == nameStore &&
      other.numberTable == numberTable &&
      other.username == username &&
      other.idUser == idUser &&
      other.dateTime == dateTime &&
      other.bookingDate == bookingDate &&
      other.status == status &&
      other.phone == phone;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      checkIn.hashCode ^
      idStore.hashCode ^
      nameStore.hashCode ^
      numberTable.hashCode ^
      username.hashCode ^
      idUser.hashCode ^
      dateTime.hashCode ^
      bookingDate.hashCode ^
      status.hashCode ^
      phone.hashCode;
  }
}
