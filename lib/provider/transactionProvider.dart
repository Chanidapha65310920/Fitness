import 'package:account/model/transaction.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> transactions = [
    Transaction(title: 'หนังสือ', amount: 1000, dateTime: DateTime.now()),
    Transaction(title: 'เสื้อยืด', amount: 200, dateTime: DateTime.now()),
    Transaction(title: 'รองเท้า', amount: 1500, dateTime: DateTime.now()),
    Transaction(title: 'กระเป๋า', amount: 1000, dateTime: DateTime.now()),
    Transaction(title: 'KFC', amount: 300, dateTime: DateTime.now()),
  ];

  List<Transaction> getTransactions() {
    return transactions;
  }

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
  }
}