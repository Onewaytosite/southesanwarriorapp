import 'package:flutter/material.dart';

// 1. Data Model
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
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<PasswordEntry> _passwords = [];

  // ฟังก์ชันแสดง Dialog
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
                Navigator.pop(context);
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // แก้ไข Error: ย้ายมาไว้ใน Class และทำให้สมบูรณ์
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
        scrolledUnderElevation: 0,
        title: const Text("My Vault", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: _showAddDialog,
              ),
            ),
          ),
        ],
      ),
      body: _passwords.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ใช้สีแบบดั้งเดิมถ้า withValues มีปัญหาในบางเครื่อง
                  Icon(Icons.vpn_key_outlined, size: 80, color: Colors.white.withOpacity(0.1)),
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
              onPressed: () => setState(() => _passwords.remove(entry)),
            ),
          ],
        ),
      ),
    );
  }
}