import 'package:flutter/material.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String pin = "";

  void _inputPin(String val) {
    if (pin.length < 6) {
      setState(() => pin += val);
    }
    if (pin.length == 6) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _backspace() {
    if (pin.isNotEmpty) {
      setState(() => pin = pin.substring(0, pin.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text(
              "ENTER PIN",
              style: TextStyle(fontSize: 20, letterSpacing: 4, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 16, height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < pin.length ? Colors.white : Colors.white10,
                  border: Border.all(color: Colors.white24),
                ),
              )),
            ),
            const Spacer(),
            _buildKeyboard(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Column(
      children: [
        for (var row in [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((n) => _numpadButton(n)).toList(),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 100),
            _numpadButton("0"),
            _numpadButton("⌫", isIcon: true),
          ],
        ),
      ],
    );
  }

  Widget _numpadButton(String text, {bool isIcon = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: () => isIcon ? _backspace() : _inputPin(text),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white12),
            color: Colors.white.withValues(alpha: 0.05),
          ),
          child: Center(
            child: Text(text, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300)),
          ),
        ),
      ),
    );
  }
}