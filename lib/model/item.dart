import 'package:passwordvault/services/database_creator.dart';
class Item{
  int id;
  String application;
  String username;
  String password;

  Item({this.id, this.application, this.username, this.password});

  Item.fromJson(Map<String,dynamic> item){
    this.id = item[DatabaseCreator.COLUMN_ID];
    this.application = item[DatabaseCreator.COLUMN_APPLICATION];
    this.username = item[DatabaseCreator.COLUMN_USERNAME];
    this.password = item[DatabaseCreator.COLUMN_PASSWORD];
  }
}