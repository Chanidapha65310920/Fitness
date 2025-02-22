import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/model/transactionItem.dart';
import 'package:account/provider/transactionProvider.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  final TransactionItem item;

  const EditScreen({super.key, required this.item});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController usageController;
  late TextEditingController brandController;
  late TextEditingController serialNumberController;
  String? selectedType;
  String? selectedStatus;
  DateTime? purchaseDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    usageController = TextEditingController(text: widget.item.usage);
    brandController = TextEditingController(text: widget.item.brand);
    serialNumberController = TextEditingController(text: widget.item.serialNumber);
    selectedType = widget.item.type;
    selectedStatus = widget.item.status;
    purchaseDate = widget.item.purchaseDate;
  }

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
          'แก้ไขข้อมูลเครื่องเล่น',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อเครื่องเล่น',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
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
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                  validator: (value) {
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
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
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
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
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
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
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
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                  validator: (value) {
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
                        if (_formKey.currentState!.validate()) {
                          var provider = Provider.of<TransactionProvider>(
                              context,
                              listen: false);
                          TransactionItem item = TransactionItem(
                            keyID: widget.item.keyID,
                            title: titleController.text,
                            type: selectedType ?? "",
                            usage: usageController.text,
                            brand: brandController.text,
                            serialNumber: serialNumberController.text,
                            purchaseDate: purchaseDate ?? DateTime.now(),
                            status: selectedStatus ?? "",
                            dateTime: DateTime.now(),
                          );
                          provider.updateTransaction(item);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'บันทึกการแก้ไข',
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
      ),
    );
  }
}
