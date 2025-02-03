import 'package:account/model/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:account/database/transactionDB.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionItem> transactions = [
  //   Transaction(title: 'เสื้อยืด', amount: 200, dateTime: DateTime(2024, 12, 1, 9, 0)),
  //   Transaction(title: 'รองเท้า', amount: 1500, dateTime: DateTime(2024, 11, 1, 9, 0)),
  //   Transaction(title: 'กระเป๋า', amount: 1000, dateTime: DateTime(2024, 12, 24, 9, 0)),
  ];

  List<TransactionItem> getTransaction() => transactions;

  initData() async {
    var db = TransactionDB(dbName: 'transaction.db');
    transactions = await db.loadAllData();
    notifyListeners();
  }

  Future<void> loadTransaction() async {
    var db = TransactionDB(dbName: 'transaction.db');

    transactions = await db.loadAllData();
    notifyListeners();
  }

  void addTransaction(TransactionItem transaction) async {
    var db = TransactionDB(dbName: 'transaction.db');
    
    await db.insertDatabase(transaction);
    transactions = await db.loadAllData();
    notifyListeners();
  }

  deleteTransaction(TransactionItem transaction) async {
    var db = TransactionDB(dbName: 'transaction.db');
    await db.deleteData(transaction);
    transactions = await db.loadAllData();
    notifyListeners();
  }

  List<TransactionItem> get latestTransactions {
    List<TransactionItem> sortedList = List.from(transactions);
    sortedList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return sortedList;
  }

  List<TransactionItem> get oldestTransactions {
    List<TransactionItem> sortedList = List.from(transactions);
    sortedList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return sortedList;
  }

}