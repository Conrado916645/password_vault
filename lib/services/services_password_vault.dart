import 'package:passwordvault/model/item.dart';
import 'package:passwordvault/services/database_creator.dart';

class ServicesPasswordVault {
  static Future<List<Item>> getAllUItem() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.TABLE_NAME}''';
    final data = await db.rawQuery(sql);
    List<Item> items = List();

    for (final node in data) {
      final item = Item.fromJson(node);
      items.add(item);
    }
    return items;
  }

  static Future<Item> getItem(int id) async {
    final sql = '''SELECT * FROM ${DatabaseCreator.TABLE_NAME}
    WHERE ${DatabaseCreator.COLUMN_ID} = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final todo = Item.fromJson(data.first);
    return todo;
  }

  static Future<void> addItem(Item item) async {

    final sql = '''INSERT INTO ${DatabaseCreator.TABLE_NAME}
    (
      ${DatabaseCreator.COLUMN_ID},
      ${DatabaseCreator.COLUMN_APPLICATION},
      ${DatabaseCreator.COLUMN_USERNAME},
      ${DatabaseCreator.COLUMN_PASSWORD}
    )
    VALUES (?,?,?,?)''';
    List<dynamic> params = [item.id, item.application, item.username, item.password];
    final result = await db.rawInsert(sql, params);
    DatabaseCreator.databaseLog('Add new user', sql, null, result, params);
  }

  static Future<void> deleteItem(Item item) async {
    final sql = '''DELETE FROM ${DatabaseCreator.TABLE_NAME}
    WHERE ${DatabaseCreator.COLUMN_ID} = ?
    ''';

    List<dynamic> params = [item.id];
    final result = await db.rawDelete(sql, params);

    DatabaseCreator.databaseLog('Delete user', sql, null, result, params);
  }

  static Future<void> updateItem(Item item) async {
    final sql = '''UPDATE ${DatabaseCreator.TABLE_NAME}
    SET ${DatabaseCreator.COLUMN_APPLICATION} = ?,
    ${DatabaseCreator.COLUMN_USERNAME} = ?,
    ${DatabaseCreator.COLUMN_PASSWORD} = ?
    
    WHERE ${DatabaseCreator.COLUMN_ID} = ?
    ''';

    List<dynamic> params = [item.application, item.username, item.password,item.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Update user', sql, null, result, params);
  }

  static Future<int> itemCount() async {
    final data = await db.rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.TABLE_NAME}''');
    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}
