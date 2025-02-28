import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/model/transactionItem.dart';

class TransactionDB {
  String dbName;
  static Database? _database;

  TransactionDB({required this.dbName});

   Future<Database> openDatabase() async {
    if (_database != null) {
      return _database!; // ถ้ามี Database อยู่แล้วให้ใช้ตัวเดิม
    }

    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    _database = await dbFactory.openDatabase(dbLocation);
    return _database!;
  }

  // ✅ ฟังก์ชันเพิ่มข้อมูลเข้า Database (เพิ่ม imagePath)
  Future<int> insertDatabase(TransactionItem item) async {
    var db = await openDatabase(); // เปิดฐานข้อมูล
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
      'imagePath': item.imagePath,
      'repairDetails': item.repairDetails, 
    });

    return keyID;
}


  // ✅ ฟังก์ชันโหลดข้อมูลทั้งหมดจาก Database (รองรับ imagePath)
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
        imagePath: record['imagePath']?.toString(), 
        repairDetails: record['repairDetails']?.toString(),
      );
    }).toList();

    return transactions;
  }

  // ✅ ฟังก์ชันอัปเดตข้อมูล (รองรับ imagePath)
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
        'imagePath': item.imagePath,
        'repairDetails': item.repairDetails,
      },
      finder: Finder(filter: Filter.equals(Field.key, item.keyID)),
    );

  }

  // ✅ ฟังก์ชันลบข้อมูล (ไม่ต้องแก้)
  Future<void> deleteData(TransactionItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');
    await store.delete(db,
        finder: Finder(filter: Filter.equals(Field.key, item.keyID)));
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
