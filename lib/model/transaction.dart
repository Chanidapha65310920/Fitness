class TransactionItem {
  int? keyID;
  String title;
  double amount;
  DateTime dateTime;

  TransactionItem({this.keyID, required this.title, required this.amount, required this.dateTime});
}
