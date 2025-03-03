import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/formAdd.dart';
import 'package:account/editScreen.dart';
import 'package:account/detailScreen.dart';
import 'package:account/model/fitness_Model.dart';
import 'package:account/provider/fitness_Provider.dart';
import 'dart:io';

// เพิ่ม import หน้าต่างๆ ที่ใช้
import 'package:account/index.dart';
import 'package:account/reportIssue.dart';

main() {
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
        title: 'Fitness',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade300),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'เครื่องเล่นฟิตเนส'),
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
  String? _selectedType; // ใช้สำหรับกรองประเภทเครื่องเล่น

  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).initData();
  }

  void _filterByType(String? value) {
    setState(() {
      _selectedType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB3D7FF),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent], // ✅ ไล่สีฟ้า
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16), // ✅ ปรับระยะขอบ
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // ✅ พื้นหลังสีขาว
                borderRadius: BorderRadius.circular(12), // ✅ ขอบมน
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12, // ✅ เงาเบา ๆ
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12), // ✅ ระยะในปุ่ม
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    hint: const Text(
                      "กรองประเภท",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onChanged: _filterByType,
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down_circle,
                        size: 28), // ✅ เปลี่ยนไอคอน
                    iconEnabledColor: Colors.blue.shade900,
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                    items: ['ทั้งหมด', 'คาร์ดิโอ', 'เวทเทรนนิ่ง']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value == 'ทั้งหมด' ? null : value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // ✅ เพิ่มเมนู Drawer (เมนูด้านข้าง)
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
                  SizedBox(height: 70),
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
          List<TransactionItem> transactions = provider.transactions;

          // กรองข้อมูลตามประเภทที่เลือก
          if (_selectedType != null) {
            transactions = transactions
                .where((item) => item.type == _selectedType)
                .toList();
          }

          if (transactions.isEmpty) {
            return Center(
              child: Text('ไม่มีรายการ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              TransactionItem data = transactions[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(item: data),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ แสดงรูปภาพ
                        if (data.imagePath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.file(
                                File(data.imagePath!),
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                        const SizedBox(height: 15),

                        // ✅ แสดงชื่อเครื่องเล่น
                        Text(
                          data.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),

                        // ✅ แสดงประเภท
                        Text(
                          "ประเภท: ${data.type}",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),

                        // ✅ แสดงสถานะ
                        Text(
                          "สถานะ: ${data.status}",
                          style: TextStyle(
                            color: data.status == 'ใช้งานได้'
                                ? Colors.green
                                : data.status == 'กำลังซ่อม'
                                    ? Colors.orange
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        // ✅ ปุ่มแก้ไขและลบ (ยังคงอยู่)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ✅ ปุ่มแก้ไข (พื้นหลังมน)
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditScreen(item: data),
                                  ),
                                );
                                if (result == true) {
                                  setState(() {}); // รีเฟรชรายการ
                                }
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text("แก้ไข"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // ✅ พื้นหลังสีฟ้า
                                foregroundColor: Colors.white, // ✅ ข้อความสีขาว
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // ✅ ขอบมน
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8), // ✅ ปรับขนาดปุ่ม
                              ),
                            ),

                            // ✅ ปุ่มลบ (พื้นหลังมน)
                            ElevatedButton.icon(
                              onPressed: () {
                                if (data == null) {
                                  Navigator.pop(context); // ✅ ปิด Dialog ก่อน
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "เกิดข้อผิดพลาด: ไม่พบข้อมูลที่จะลบ")),
                                  );
                                  return;
                                }

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('ยืนยันการลบ'),
                                    content: const Text(
                                        'คุณแน่ใจหรือว่าต้องการลบรายการนี้?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('ยกเลิก'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          var provider =
                                              Provider.of<TransactionProvider>(
                                                  context,
                                                  listen: false);

                                          provider.deleteTransaction(data);

                                          provider
                                              .notifyListeners(); // ✅ รีเฟรช UI

                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(); // ✅ ปิด Dialog

                                          // ✅ แจ้งเตือนว่าลบสำเร็จ
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text("ลบข้อมูลสำเร็จ")),
                                          );
                                        },
                                        child: const Text('ยืนยัน',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              label: const Text("ลบ"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ],
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
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FormScreen()));
          if (result != null && result is Map<String, dynamic>) {
            Provider.of<TransactionProvider>(context, listen: false)
                .addTransaction(TransactionItem(
              title: result['title'],
              imagePath: result['imagePath'],
              type: result['type'],
              usage: result['usage'],
              brand: result['brand'],
              serialNumber: result['serialNumber'],
              purchaseDate: result['purchaseDate'],
              status: result['status'],
              dateTime: DateTime.now(),
            ));
          }
        },
        backgroundColor: const Color.fromARGB(255, 51, 113, 206),
        child: const Icon(Icons.add),
      ),
    );
  }
}
