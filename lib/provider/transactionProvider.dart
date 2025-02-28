import 'package:account/model/transactionItem.dart';
import 'package:flutter/foundation.dart';
import 'package:account/database/transaction_db.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionDB db = TransactionDB(dbName: 'transaction.db');

  List<TransactionItem> transactions = [];

  List<TransactionItem> getTransaction() => transactions;

  Future<void> initData() async {
    transactions = await db.loadAllData();
    notifyListeners();
  }

  Future<void> loadTransaction() async {
    transactions = await db.loadAllData();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionItem transaction) async {
    await db.insertDatabase(transaction);
    await loadTransaction(); // โหลดข้อมูลใหม่แทนการเรียกซ้ำ
  }

  Future<void> updateTransaction(TransactionItem transaction) async {
    await db.updateData(transaction);
    await loadTransaction(); // โหลดข้อมูลใหม่แทนการเรียกซ้ำ
  }

  Future<void> deleteTransaction(TransactionItem transaction) async {
    await db.deleteData(transaction);
    await loadTransaction(); // โหลดข้อมูลใหม่แทนการเรียกซ้ำ
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

  List<TransactionItem> getRepairTransactions() {
    return transactions.where((item) => item.status == "แจ้งซ่อม").toList();
  }

  
}
