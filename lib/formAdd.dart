import 'package:account/model/transactionItem.dart';
import 'package:account/provider/transactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final usageController = TextEditingController();
  final brandController = TextEditingController();
  final serialNumberController = TextEditingController();

  String? selectedType;
  String? selectedStatus;
  DateTime? purchaseDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != purchaseDate) {
      setState(() {
        purchaseDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            'เพิ่มเครื่องเล่น',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(  // ✅ ครอบ Form ด้วย ScrollView เพื่อป้องกันการซ่อน
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,  // ✅ ป้องกันการถูกตัดออก
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        labelText: 'ชื่อเครื่องเล่น',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    autofocus: true,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกชื่อเครื่องเล่น';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'ประเภทเครื่องเล่น',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    items: ['คาร์ดิโอ', 'เวทเทรนนิ่ง']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกประเภทเครื่องเล่น';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: usageController,
                    decoration: const InputDecoration(
                        labelText: 'วิธีใช้',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกวิธีใช้';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: brandController,
                    decoration: const InputDecoration(
                        labelText: 'แบรนด์',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกแบรนด์';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: serialNumberController,
                    decoration: const InputDecoration(
                        labelText: 'หมายเลขซีเรียล',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกหมายเลขซีเรียล';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'วันที่ซื้อ',
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: purchaseDate != null
                              ? DateFormat('dd/MM/yyyy').format(purchaseDate!)
                              : '',
                        ),
                        validator: (value) {
                          if (purchaseDate == null) {
                            return 'กรุณาเลือกวันที่ซื้อ';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'สถานะเครื่อง',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    items: ['ใช้งานได้', 'กำลังซ่อม', 'เลิกใช้งาน']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกสถานะเครื่อง';
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
                            var provider = Provider.of<TransactionProvider>(
                                context,
                                listen: false);
                            TransactionItem item = TransactionItem(
                                title: titleController.text,
                                type: selectedType ?? "",
                                usage: usageController.text,
                                brand: brandController.text,
                                serialNumber: serialNumberController.text,
                                purchaseDate: purchaseDate ?? DateTime.now(),
                                status: selectedStatus ?? "",
                                dateTime: DateTime.now());
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
                          Navigator.pop(context);
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
          ),
        ));
  }
}
