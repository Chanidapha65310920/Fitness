import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:account/provider/fitness_Provider.dart';
import 'package:account/model/fitness_Model.dart';
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
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'เพิ่มเครื่องเล่น',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5, // ✅ เพิ่มเงาให้ Card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ หัวข้อ
                  const Text(
                    "เพิ่มข้อมูลเครื่องเล่น",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ✅ ช่องกรอก "ชื่อเครื่องเล่น"
                  _buildTextField(
                      titleController, "ชื่อเครื่องเล่น", Icons.fitness_center),

                  // ✅ เลือกรูปภาพ
                  Center(
                    child: Column(
                      children: [
                        _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(_imageFile!,
                                    width: 200, height: 200, fit: BoxFit.cover),
                              )
                            : const Text(
                                'ยังไม่ได้เลือกรูป',
                                style: TextStyle(fontSize: 16),
                              ),
                        const SizedBox(height: 8),

// ✅ ปุ่ม "เลือกรูปภาพ" ที่ยาวขึ้น แต่ไม่เต็มหน้าจอ
                        SizedBox(
                          width: 200, // ✅ กำหนดความกว้างปุ่มให้พอดี
                          child: _buildButton(
                            text: "เลือกรูปภาพ",
                            color: Colors.blueAccent,
                            icon: Icons.image,
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                  ),
const SizedBox(height: 8),

                  // ✅ Dropdown "ประเภทเครื่องเล่น"
                  _buildDropdown(
                    label: "ประเภทเครื่องเล่น",
                    value: selectedType,
                    items: ['คาร์ดิโอ', 'เวทเทรนนิ่ง'],
                    icon: Icons.category,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),

                  // ✅ ช่องกรอก "วิธีใช้"
                  _buildTextField(
                      usageController, "วิธีใช้", Icons.description),

                  // ✅ ช่องกรอก "แบรนด์"
                  _buildTextField(
                      brandController, "แบรนด์", Icons.branding_watermark),

                  // ✅ ช่องกรอก "หมายเลขซีเรียล"
                  _buildTextField(serialNumberController, "หมายเลขซีเรียล",
                      Icons.confirmation_number),

                  // ✅ เลือกวันที่ซื้อ
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        TextEditingController(
                          text: purchaseDate != null
                              ? DateFormat('dd/MM/yyyy').format(purchaseDate!)
                              : '',
                        ),
                        "วันที่ซื้อ",
                        Icons.calendar_today,
                      ),
                    ),
                  ),

                  // ✅ Dropdown "สถานะเครื่อง"
                  _buildDropdown(
                    label: "สถานะเครื่อง",
                    value: selectedStatus,
                    items: ['ใช้งานได้', 'กำลังซ่อม', 'เลิกใช้งาน'],
                    icon: Icons.check_circle,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // ✅ ปุ่ม "เพิ่มข้อมูล" และ "ยกเลิก"
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          text: "เพิ่มข้อมูล",
                          color: Colors.green,
                          icon: Icons.save,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final newTransaction = TransactionItem(
                                title: titleController.text,
                                type: selectedType ?? 'ไม่ระบุ',
                                usage: usageController.text,
                                brand: brandController.text,
                                serialNumber: serialNumberController.text,
                                purchaseDate: purchaseDate ?? DateTime.now(),
                                status: selectedStatus ?? 'ไม่ระบุ',
                                dateTime: DateTime.now(),
                                imagePath: _imageFile?.path,
                              );

                              Provider.of<TransactionProvider>(context,
                                      listen: false)
                                  .addTransaction(newTransaction);

                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildButton(
                          text: "ยกเลิก",
                          color: Colors.red,
                          icon: Icons.cancel,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// ✅ ฟังก์ชันสร้างช่องกรอกข้อมูล
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: Icon(icon, color: Colors.blue),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก$label';
          }
          return null;
        },
      ),
    );
  }

// ✅ ฟังก์ชันสร้าง Dropdown
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: Icon(icon, color: Colors.blue),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาเลือก$label';
          }
          return null;
        },
      ),
    );
  }

// ✅ ฟังก์ชันสร้างปุ่ม
  Widget _buildButton({
    required String text,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
