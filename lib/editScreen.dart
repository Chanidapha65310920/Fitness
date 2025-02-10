import 'package:account/model/transaction.dart';
import 'package:account/provider/transactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  TransactionItem item;

  EditScreen({super.key, required this.item});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    amountController.text = widget.item.amount % 1 == 0
        ? widget.item.amount.toInt().toString()
        : widget.item.amount.toString();
  }

  void _updateTransaction() {
    if (formKey.currentState!.validate()) {
      var provider = Provider.of<TransactionProvider>(context, listen: false);
      TransactionItem item = TransactionItem(
        keyID: widget.item.keyID,
        title: titleController.text,
        amount: double.parse(amountController.text),
        dateTime: widget.item.dateTime,
      );

      provider.updateTransaction(item);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            'แก้ไขข้อมูล',
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
                      onPressed: _updateTransaction,
                      child: const Text(
                        'ยืนยัน',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        var of = Navigator.of(context);
                        of.pop();
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
