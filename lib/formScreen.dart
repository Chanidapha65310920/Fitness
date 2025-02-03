import 'package:account/model/transaction.dart';
import 'package:account/provider/transactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            'เพิ่มข้อมูล',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      labelText: 'ชื่อรายการ',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  autofocus: true,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'กรุณากรอกชื่อรายการ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                      labelText: 'จำนวนเงิน',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนเงิน';
                    }
                    try {
                      double amount = double.parse(value);
                      if (amount <= 0) {
                        return 'กรุณากรอกจำนวนเงินที่มากกว่า 0';
                      }
                    } catch (e) {
                      return 'กรุณากรอกจำนวนเงินที่ถูกต้อง';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          var provider = Provider.of<TransactionProvider>(context, listen: false);
                          TransactionItem item = TransactionItem(
                            title: titleController.text, 
                            amount: double.parse(amountController.text), 
                            dateTime: DateTime.now()
                          );
                          provider.addTransaction(item);
                          Navigator.pop(context);
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
                        var of = Navigator.of(context);
                        of.pop(); // ย้อนกลับไปหน้าก่อนหน้า
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
        ));
  }
}
