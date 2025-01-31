import 'package:account/model/transaction.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [
    Transaction(title: 'เสื้อยืด', amount: 200, dateTime: DateTime(2024, 12, 1, 9, 0)),
    Transaction(title: 'รองเท้า', amount: 1500, dateTime: DateTime(2024, 11, 1, 9, 0)),
    Transaction(title: 'กระเป๋า', amount: 1000, dateTime: DateTime(2024, 12, 24, 9, 0)),
  ];

  List<Transaction> get transactions => _transactions;

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    notifyListeners();
  }

  List<Transaction> get latestTransactions {
    _transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return _transactions;
  }

  List<Transaction> get oldestTransactions {
    _transactions.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return _transactions;
  }
}