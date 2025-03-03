import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:account/model/fitness_Model.dart';

class DetailScreen extends StatelessWidget {
  final TransactionItem item;

  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB3D7FF),
      appBar: AppBar(
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ แสดงรูปภาพ (ถ้ามี)
            if (item.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(item.imagePath!),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            // ✅ ชื่อเครื่องเล่น
            Text(
              "รายละเอียด",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 20, 128, 216)),
            ),

            const SizedBox(height: 10),

            _buildDetailRow("ประเภท", item.type),
            _buildDetailRow("วิธีใช้", item.usage.isNotEmpty ? item.usage : "ไม่มีข้อมูล"),
            _buildDetailRow("แบรนด์", item.brand),
            _buildDetailRow("หมายเลขซีเรียล", item.serialNumber),
            _buildDetailRow("วันที่ซื้อ", DateFormat('dd/MM/yyyy').format(item.purchaseDate)),
            _buildDetailRow("สถานะ", item.status),

            const SizedBox(height: 20),

            // ✅ ปุ่มปิด
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                ),
                child: const Text("กลับไปหน้าหลัก", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ ฟังก์ชันสร้างแถวข้อมูล
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
