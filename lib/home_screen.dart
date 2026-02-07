import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// 1. Data Model พร้อมฟังก์ชันแปลงเป็น JSON
class PasswordEntry {
  final String title;
  final String username;
  final String password;
  bool isVisible;

  PasswordEntry({
    required this.title,
    required this.username,
    required this.password,
    this.isVisible = false,
  });

  // แปลงจาก Object เป็น Map เพื่อเซฟลงเครื่อง
  Map<String, dynamic> toMap() => {
    'title': title,
    'username': username,
    'password': password,
  };

  // แปลงจาก Map กลับเป็น Object ตอนโหลดข้อมูล
  factory PasswordEntry.fromMap(Map<String, dynamic> map) => PasswordEntry(
    title: map['title'] ?? '',
    username: map['username'] ?? '',
    password: map['password'] ?? '',
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<PasswordEntry> _passwords = [];

  @override
  void initState() {
    super.initState();
    _loadData(); // โหลดข้อมูลทันทีที่เปิดแอป
  }

  // --- ระบบจัดการข้อมูล (Storage) ---

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('saved_passwords');
    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        _passwords.clear();
        _passwords.addAll(decoded.map((m) => PasswordEntry.fromMap(m)).toList());
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_passwords.map((p) => p.toMap()).toList());
    await prefs.setString('saved_passwords', encoded);
  }

  // ------------------------------

  void _showAddDialog() {
    final titleController = TextEditingController();
    final userController = TextEditingController();
    final passController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2D37),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Add New Password", style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(titleController, "App Name", Icons.apps),
              const SizedBox(height: 10),
              _buildTextField(userController, "Username / Email", Icons.person_outline),
              const SizedBox(height: 10),
              _buildTextField(passController, "Password", Icons.lock_outline, isPassword: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              if (titleController.text.isNotEmpty && passController.text.isNotEmpty) {
                setState(() {
                  _passwords.add(PasswordEntry(
                    title: titleController.text,
                    username: userController.text,
                    password: passController.text,
                  ));
                });
                _saveData(); // บันทึกข้อมูลลงเครื่องทันทีที่กด Save
                Navigator.pop(context);
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("My Vault", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.add, color: Colors.white, size: 20),
            ),
            onPressed: _showAddDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _passwords.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.vpn_key_outlined, size: 80, color: Colors.white.withValues(alpha: 0.1)),
                  const SizedBox(height: 16),
                  const Text("No passwords saved yet.", style: TextStyle(color: Colors.white24)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _passwords.length,
              itemBuilder: (context, index) => _passwordCard(_passwords[index]),
            ),
    );
  }

  Widget _passwordCard(PasswordEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D37),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.shield, color: Colors.white, size: 20),
        ),
        title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.username, style: const TextStyle(color: Colors.white38)),
            const SizedBox(height: 4),
            Text(
              entry.isVisible ? entry.password : "••••••••",
              style: TextStyle(
                color: entry.isVisible ? Colors.greenAccent : Colors.white24,
                letterSpacing: entry.isVisible ? 0 : 2,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                entry.isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.white38,
                size: 20,
              ),
              onPressed: () => setState(() => entry.isVisible = !entry.isVisible),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
              onPressed: () {
                setState(() => _passwords.remove(entry));
                _saveData(); // บันทึกข้อมูลใหม่หลังจากลบ
              },
            ),
          ],
        ),
      ),
    );
  }
}