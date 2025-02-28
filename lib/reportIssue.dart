import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/model/transactionItem.dart';
import 'package:account/provider/transactionProvider.dart';
import 'dart:io';

// Import หน้าต่างๆ
import 'package:account/index.dart';
import 'package:account/main.dart';

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "รายการแจ้งซ่อม",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent], // ✅ ไล่สี
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5, // ✅ เพิ่มเงา
      ),

      // ✅ เพิ่มเมนู Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.lightBlueAccent
                  ], // โทนฟ้าแบบไล่สี
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.fitness_center, color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text(
                    "เมนู",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading:
                  Icon(Icons.home, color: Colors.blueAccent), // เปลี่ยนสีไอคอน
              title: Text(
                'หน้าหลัก',
                style: TextStyle(
                    color: Colors.blue[900], fontWeight: FontWeight.w600),
              ),
              onTap: () {
                if (ModalRoute.of(context)?.settings.name != '/index') {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => IndexPage()),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.fitness_center, color: Colors.blueAccent),
              title: Text(
                'รายการเครื่องเล่นฟิตเนส',
                style: TextStyle(
                    color: Colors.blue[900], fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context); // ✅ ปิด Drawer ก่อน
                Navigator.pushReplacement(
                  // ✅ ไปที่หน้า MainPage
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report_problem, color: Colors.blueAccent),
              title: Text(
                'รายการแจ้งซ่อม',
                style: TextStyle(
                    color: Colors.blue[900], fontWeight: FontWeight.w600),
              ),
              onTap: () {
                if (ModalRoute.of(context)?.settings.name != '/reportIssue') {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ReportIssuePage()),
                  );
                }
              },
            ),
          ],
        ),
      ),

      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          List<TransactionItem> repairList = provider.transactions
              .where((item) => item.status == "แจ้งซ่อม")
              .toList();

          if (repairList.isEmpty) {
            return const Center(
              child: Text(
                'ไม่มีรายการแจ้งซ่อม',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: repairList.length,
            itemBuilder: (context, index) {
              TransactionItem data = repairList[index];

              return Card(
                elevation: 5,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: data.imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(data.imagePath!),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.orange.shade700,
                          child: const Icon(Icons.build, color: Colors.white),
                        ),
                  title: Text(data.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ประเภท: ${data.type}',
                          style: TextStyle(color: Colors.grey[600])),
                      Text(
                        'สถานะ: ${data.status}',
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      if (data.repairDetails != null &&
                          data.repairDetails!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'รายละเอียดการซ่อม: ${data.repairDetails}',
                            style: TextStyle(
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      final provider = Provider.of<TransactionProvider>(
                        context,
                        listen: false,
                      );

                      final updatedTransaction = TransactionItem(
                        keyID: data.keyID,
                        title: data.title,
                        type: data.type,
                        usage: data.usage,
                        brand: data.brand,
                        serialNumber: data.serialNumber,
                        purchaseDate: data.purchaseDate,
                        status: "ใช้งานได้",
                        dateTime: DateTime.now(),
                        imagePath: data.imagePath,
                        repairDetails: data.repairDetails,
                      );

                      provider.updateTransaction(updatedTransaction);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${data.title} อัปเดตเป็น 'ใช้งานได้'"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("ซ่อมเรียบร้อย",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),

                  // ✅ เมื่อกด ListTile จะไปที่หน้า ReportDetailPage
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReportDetailPage(transaction: data),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  
  }
}

// ✅ สร้างหน้าแสดงรายละเอียดของรายการแจ้งซ่อม
class ReportDetailPage extends StatelessWidget {
  final TransactionItem transaction;

  const ReportDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "รายละเอียดการแจ้งซ่อม",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent], // ✅ ไล่สี
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5, // ✅ เพิ่มเงา
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5, // ✅ เพิ่มเงา
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ แสดงรูปภาพเครื่องเล่น
                Center(
                  child: transaction.imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(transaction.imagePath!),
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        )
                      : const Icon(Icons.build, size: 100, color: Colors.orange),
                ),

                const SizedBox(height: 20),

                // ✅ ชื่อเครื่องเล่น
                Center(
                  child: Text(
                    transaction.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(thickness: 1.5), // ✅ เส้นแบ่ง

                // ✅ รายละเอียดเครื่องเล่น
                _buildDetailRow("ประเภท", transaction.type, Icons.category),
                _buildDetailRow("แบรนด์", transaction.brand, Icons.branding_watermark),
                _buildDetailRow("หมายเลขซีเรียล", transaction.serialNumber, Icons.confirmation_number),
                
                _buildStatusRow("สถานะ", transaction.status),

                if (transaction.repairDetails != null &&
                    transaction.repairDetails!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Divider(thickness: 1.5),
                      const Text(
                        "รายละเอียดการซ่อม:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        transaction.repairDetails!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ ฟังก์ชันสร้างแถวข้อมูลทั่วไป
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange.shade700, size: 24),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ ฟังก์ชันสร้างแถวสำหรับสถานะ
  Widget _buildStatusRow(String label, String status) {
    Color statusColor = status == "แจ้งซ่อม" ? Colors.red : Colors.green;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: statusColor, size: 24),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}