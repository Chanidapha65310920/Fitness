class TransactionItem {
  final int? keyID; // ใช้ keyId เป็น Primary Key
  final String title;
  final String type;
  final String usage;
  final String brand;
  final String serialNumber;
  final DateTime purchaseDate;
  final String status;
  final DateTime dateTime;
  final String? imagePath;  // เก็บพาธรูปภาพ
  final String? repairDetails;

  TransactionItem({
    this.keyID,  // ให้ keyId เป็น optional ในกรณีที่ยังไม่ได้ถูกบันทึกลงฐานข้อมูล
    required this.title,
    required this.type,
    required this.usage,
    required this.brand,
    required this.serialNumber,
    required this.purchaseDate,
    required this.status,
    required this.dateTime,
    this.imagePath,  
    this.repairDetails,
  });

  // แปลงเป็น JSON สำหรับการบันทึกลงฐานข้อมูล
  Map<String, dynamic> toJson() => {
        'keyId': keyID,  // เปลี่ยนจาก id เป็น keyId
        'title': title,
        'type': type,
        'usage': usage,
        'brand': brand,
        'serialNumber': serialNumber,
        'purchaseDate': purchaseDate.toIso8601String(),
        'status': status,
        'dateTime': dateTime.toIso8601String(),
        'imagePath': imagePath,
        'repairDetails': repairDetails,
      };

  // โหลดข้อมูลจาก JSON
  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      keyID: json['keyID'],  // โหลด keyId
      title: json['title'],
      type: json['type'],
      usage: json['usage'],
      brand: json['brand'],
      serialNumber: json['serialNumber'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      status: json['status'],
      dateTime: DateTime.parse(json['dateTime']),
      imagePath: json['imagePath'],
      repairDetails: json['repairDetails'],
    );
  }
}
