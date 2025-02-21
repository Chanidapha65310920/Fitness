import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:account/model/transactionItem.dart';

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

  // ฟังก์ชันเพิ่มข้อมูลเข้า Database
  Future<int> insertDatabase(TransactionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    int keyID = await store.add(db, {
      'title': item.title,
      'type': item.type,
      'usage': item.usage,
      'brand': item.brand,
      'serialNumber': item.serialNumber,
      'purchaseDate': item.purchaseDate.toIso8601String(),
      'status': item.status,
      'date': item.dateTime.toIso8601String(),
    });

    db.close();
    return keyID;
  }

  // ฟังก์ชันโหลดข้อมูลทั้งหมดจาก Database
  Future<List<TransactionItem>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('date', false)]));

    List<TransactionItem> transactions = snapshot.map((record) {
      return TransactionItem(
        keyID: record.key,
        title: record['title'].toString(),
        type: record['type'].toString(),
        usage: record['usage'].toString(),
        brand: record['brand'].toString(),
        serialNumber: record['serialNumber'].toString(),
        purchaseDate: DateTime.parse(record['purchaseDate'].toString()),
        status: record['status'].toString(),
        dateTime: DateTime.parse(record['date'].toString()),
      );
    }).toList();

    db.close();
    return transactions;
  }

  // ฟังก์ชันลบข้อมูล
  Future<void> deleteData(TransactionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');
    await store.delete(db,
        finder: Finder(filter: Filter.equals(Field.key, item.keyID)));
    db.close();
  }

  // ฟังก์ชันอัปเดตข้อมูล
  Future<void> updateData(TransactionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    await store.update(
        db,
        {
          'title': item.title,
          'type': item.type,
          'usage': item.usage,
          'brand': item.brand,
          'serialNumber': item.serialNumber,
          'purchaseDate': item.purchaseDate.toIso8601String(),
          'status': item.status,
          'date': item.dateTime.toIso8601String(),
        },
        finder: Finder(filter: Filter.equals(Field.key, item.keyID)));
    db.close();
  }
}
