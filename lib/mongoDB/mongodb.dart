import 'dart:developer';
import 'package:hangout/mongoDB/connention.dart';
import 'package:hangout/mongoDB/models/favoriteModels.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONNECT);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
  }

  static Future<String> insert(FavModels data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Insert";
      } else {
        return "Something wrong";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
