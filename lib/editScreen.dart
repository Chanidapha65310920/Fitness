import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/model/fitness_Model.dart';
import 'package:account/provider/fitness_Provider.dart';
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
  late TextEditingController repairDetailsController;
  String? selectedType;
  String? selectedStatus;
  DateTime? purchaseDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    usageController = TextEditingController(text: widget.item.usage);
    brandController = TextEditingController(text: widget.item.brand);
    serialNumberController =
        TextEditingController(text: widget.item.serialNumber);
    repairDetailsController =
        TextEditingController(); // ✅ ช่องรายละเอียดการซ่อม (เริ่มต้นเป็นค่าว่าง)
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
      backgroundColor: Color(0xFFB3D7FF),
      appBar: AppBar(
        title: const Text(
          'แก้ไขข้อมูลเครื่องเล่น',
          style: TextStyle(fontWeight: FontWeight.bold),
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
        elevation: 4, // ✅ เพิ่มเงาให้ AppBar ดูมีมิติ
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5, // ✅ เพิ่มเงาให้ Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ หัวข้อ

                    const SizedBox(height: 16),

                    // ✅ ช่องกรอก "ชื่อเครื่องเล่น"
                    _buildTextField(titleController, "ชื่อเครื่องเล่น",
                        Icons.fitness_center),

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
                      items: [
                        'ใช้งานได้',
                        'แจ้งซ่อม',
                        'กำลังซ่อม',
                        'เลิกใช้งาน'
                      ],
                      icon: Icons.check_circle,
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),

                    // ✅ ช่องกรอกรายละเอียดการซ่อม (แสดงเฉพาะเมื่อเลือก "แจ้งซ่อม")
                    if (selectedStatus == "แจ้งซ่อม") ...[
                      _buildTextField(repairDetailsController,
                          "รายละเอียดการซ่อม", Icons.build),
                    ],

                    const SizedBox(height: 20),

                    // ✅ ปุ่ม "บันทึก" และ "ยกเลิก"
                    Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            text: "บันทึกการแก้ไข",
                            color: Colors.green,
                            icon: Icons.save,
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
                                  imagePath: widget.item.imagePath,
                                  repairDetails: selectedStatus == "แจ้งซ่อม"
                                      ? repairDetailsController.text
                                      : null,
                                );

                                provider.updateTransaction(item);
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
