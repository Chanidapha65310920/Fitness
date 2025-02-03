import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/model/transaction.dart';

class TransactionDB {
  String dbName;

  TransactionDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);
    
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  insertDatabase(TransactionItem item) async {
    var db = await this.openDatabase();

    var store = intMapStoreFactory.store('expense');

    Future<int> keyID = store.add(db, {
      'title': item.title,
      'amount': item.amount,
      'date': item.dateTime?.toIso8601String()
    });
    db.close();
    return keyID;
  }

  Future<List<TransactionItem>> loadAllData() async {
    var db = await this.openDatabase();

    var store = intMapStoreFactory.store('expense');

    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder('date', false)]));

    List<TransactionItem> transactions = [];

    for (var record in snapshot) {
      TransactionItem item = TransactionItem(
        keyID: record.key,
        title: record['title'].toString(),
        amount: double.parse(record['amount'].toString()),
        dateTime: DateTime.parse(record['date'].toString())
      );
      transactions.add(item);
    }
    db.close();
    return transactions;
  }

  deleteData(TransactionItem item) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('expense');
    store.delete(db, finder: Finder(filter: Filter.equals(Field.key, item.keyID)));
    db.close();
  }
}