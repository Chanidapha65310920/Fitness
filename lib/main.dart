import 'package:flutter/material.dart';
import 'package:account/formScreen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:account/model/transaction.dart';
import 'package:account/provider/transactionProvider.dart';
import 'package:account/database/transactionDB.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'Account',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade300),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showLatest = true;

  @override
  void initState() {
    super.initState();

    TransactionProvider provider =
        Provider.of<TransactionProvider>(context, listen: false);
    provider.initData();
  }

  void _toggleSort(String? value) {
    setState(() {
      if (value != null) {
        _showLatest = value == 'Latest';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Gradient background
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade500, Colors.teal.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _showLatest ? 'Latest' : 'Oldest',
              onChanged: _toggleSort,
              dropdownColor: Colors.white,
              style: TextStyle(
                  color: Colors.teal.shade700, fontWeight: FontWeight.bold),
              iconEnabledColor: Colors.teal.shade700,
              items: <String>['Latest', 'Oldest']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          int itemCount = provider.transactions.length;
          if (itemCount == 0) {
            return Center(
              child: Text(
                'ไม่มีรายการ',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            );
          }

          List<TransactionItem> transactions = _showLatest
              ? provider.latestTransactions
              : provider.oldestTransactions;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, int index) {
              TransactionItem data = transactions[index];
              return Card(
                elevation: 8, // ลดเงา
                margin: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8), // ลด margin ให้น้อยลง
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // คงขอบมุมโค้งมน
                ),
                color: Colors.white, // คงสีขาวของการ์ด
                shadowColor: Colors.black.withOpacity(0.1), // คงสีเงาแบบเดิม
                child: Container(
                  width: double.infinity, // ให้การ์ดเต็มความกว้างของหน้าจอ
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12), // ลด padding ให้เล็กลง
                    title: Text(
                      data.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // ลดขนาดตัวอักษรเล็กลง
                        color: Colors.teal.shade800,
                      ),
                    ),
                    subtitle: Text(
                      'วันที่บันทึกข้อมูล: ${DateFormat('dd/MM/yyyy HH:mm').format(data.dateTime)}',
                      style: TextStyle(
                        fontSize: 12, // ขนาดตัวอักษรของ subtitle เล็กลง
                        color: Colors.grey[600],
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 22, // ขนาดของ circle avatar เล็กลง
                      backgroundColor: Colors.teal.shade700,
                      child: FittedBox(
                        child: Text(
                          data.amount.toStringAsFixed(0),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // ขนาดตัวเลขใน avatar ลดลง
                          ),
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        // แสดง Dialog ยืนยันการลบ
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('ยืนยันการลบ'),
                              content:
                                  Text('คุณแน่ใจหรือว่าต้องการลบรายการนี้?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // ปิด Dialog
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // ลบรายการเมื่อผู้ใช้ยืนยัน
                                    await provider.deleteTransaction(
                                        data); // ใช้ await เพื่อให้มั่นใจว่าเสร็จสมบูรณ์ก่อนปิด Dialog
                                    Navigator.of(context)
                                        .pop(); // ปิด Dialog หลังจากลบเสร็จ
                                  },
                                  child: Text('ยืนยัน'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.red.shade600),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen()),
          );
          if (result != null && result is Map<String, dynamic>) {
            Provider.of<TransactionProvider>(context, listen: false)
                .addTransaction(TransactionItem(
                    title: result['title'],
                    amount: result['amount'],
                    dateTime: DateTime.now()));
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal.shade700,
        elevation: 8,
      ),
    );
  }
}
