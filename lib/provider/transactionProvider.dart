import 'package:account/model/transaction.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> transactions = [
    Transaction(title: 'หนังสือ', amount: 1000, dateTime: DateTime(2025, 1, 1, 9, 0)),
    Transaction(title: 'เสื้อยืด', amount: 200, dateTime: DateTime(2024, 12, 1, 9, 0)),
    Transaction(title: 'รองเท้า', amount: 1500, dateTime: DateTime(2024, 11, 1, 9, 0)),
    Transaction(title: 'กระเป๋า', amount: 1000, dateTime: DateTime(2024, 12, 24, 9, 0)),
    Transaction(title: 'KFC', amount: 300, dateTime: DateTime(2025, 1, 16, 9, 0)),
  ];

  List<Transaction> getTransactions() {
    return transactions;
  }

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    notifyListeners();
  }
}