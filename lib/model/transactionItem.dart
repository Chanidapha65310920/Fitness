class TransactionItem {
  int? keyID;
  String title;          // ชื่อเครื่องเล่น
  String type;           // ประเภทเครื่องเล่น (คาร์ดิโอ / เวทเทรนนิ่ง)
  String usage;          // วิธีใช้
  String brand;          // แบรนด์
  String serialNumber;   // หมายเลขซีเรียล
  DateTime purchaseDate; // วันที่ซื้อ
  String status;         // สถานะเครื่อง (ใช้งานได้ / กำลังซ่อม / เลิกใช้งาน)
  DateTime dateTime;     // วันที่บันทึกข้อมูล

  TransactionItem({
    this.keyID,
    required this.title,
    required this.type,
    required this.usage,
    required this.brand,
    required this.serialNumber,
    required this.purchaseDate,
    required this.status,
    required this.dateTime,
  });

  // แปลงเป็น Map สำหรับเก็บลงฐานข้อมูล
  Map<String, dynamic> toMap() {
    return {
      'keyID': keyID,
      'title': title,
      'type': type,
      'usage': usage,
      'brand': brand,
      'serialNumber': serialNumber,
      'purchaseDate': purchaseDate.toIso8601String(),
      'status': status,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // ฟังก์ชันสร้าง Object `TransactionItem` จาก Map (ใช้เวลาโหลดข้อมูลจากฐานข้อมูล)
  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      keyID: map['keyID'],
      title: map['title'] ?? "",
      type: map['type'] ?? "",
      usage: map['usage'] ?? "",
      brand: map['brand'] ?? "",
      serialNumber: map['serialNumber'] ?? "",
      purchaseDate: DateTime.tryParse(map['purchaseDate'] ?? "") ?? DateTime.now(),
      status: map['status'] ?? "",
      dateTime: DateTime.tryParse(map['dateTime'] ?? "") ?? DateTime.now(),
    );
  }
}
