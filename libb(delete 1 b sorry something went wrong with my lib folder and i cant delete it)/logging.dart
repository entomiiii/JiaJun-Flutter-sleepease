import 'package:flutter/material.dart';

class LoggingPage extends StatefulWidget {
  final DateTime selectedDate;
  const LoggingPage({super.key, required this.selectedDate});

  @override
  State<LoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {
  final TextEditingController _durationController = TextEditingController();

  // 🎨 Theme colors (same as rest of app)
  static const Color color1 = Color(0xFF0D2B5B);
  static const Color color2 = Color(0xFF91B3F1);

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.timer, color: color1),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color1.withOpacity(0.15)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: color1, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateStr =
        "${widget.selectedDate.day}/${widget.selectedDate.month}";

    return Scaffold(
      backgroundColor: color2,
      appBar: AppBar(
        title: const Text('SleepEase'),
        backgroundColor: color1,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Log Sleep Duration",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color1,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Logging for $dateStr",
              style: TextStyle(color: color1.withOpacity(0.7)),
            ),

            const SizedBox(height: 25),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Enter your sleep duration",
                    style: TextStyle(
                      color: color1.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: _durationController,
                    decoration: _inputStyle("e.g 7.5 or 7:30"),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, _durationController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Save Log",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
