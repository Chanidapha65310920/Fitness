import 'package:flutter/material.dart';
import 'package:account/formAdd.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:account/model/transactionItem.dart';
import 'package:account/provider/transactionProvider.dart';

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

              return Dismissible(
                key: Key(data.keyID.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  provider.deleteTransaction(data);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: Card(
                  elevation: 8,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.black.withOpacity(0.1),
                  child: Container(
                    width: double.infinity,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      title: Text(
                        data.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.teal.shade800,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ประเภท: ${data.type}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'สถานะ: ${data.status}',
                            style: TextStyle(
                              color: data.status == 'ใช้งานได้'
                                  ? Colors.green
                                  : data.status == 'กำลังซ่อม'
                                      ? Colors.orange
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.teal.shade700,
                        child: Text(
                          '${data.keyID}', // แสดง keyID
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
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
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('ยกเลิก'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      provider.deleteTransaction(data);
                                      Navigator.of(context).pop();
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
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal.shade700,
        elevation: 8,
      ),
    );
  }
}
