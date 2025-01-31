import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('เพิ่มข้อมูล', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: 'ชื่อรายการ',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              autofocus: true,
            ),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                  labelText: 'จำนวนเงิน',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final title = _titleController.text;
                    final amount = double.tryParse(_amountController.text) ?? 0;

                    if (title.isNotEmpty && amount > 0) {
                      // ส่งข้อมูลกลับไปยังหน้าหลัก
                      Navigator.pop(
                          context, {'title': title, 'amount': amount});
                    }
                  },
                  child: const Text(
                    'เพิ่มข้อมูล',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // ย้อนกลับไปหน้าก่อนหน้า
                  },
                  child: const Text('ยกเลิก',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
