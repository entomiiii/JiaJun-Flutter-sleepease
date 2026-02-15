
import 'dart:async';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'about.dart';
import 'logging.dart';
import 'reminders.dart';
import 'login.dart';
import 'insights.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String email;
  final String password;

  const HomePage({
    super.key,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String currentUser;
  late String currentEmail;
  late String currentPass;

  DateTime selectedDate = DateTime.now();
  final Map<String, double> dailyLogs = {};
  final double sleepTarget = 8.0;


  Map<String, dynamic>? reminderSettings;

  final List<DateTime> nextSevenDays =
      List.generate(7, (index) => DateTime.now().add(Duration(days: index)));


  double totalDebt = 0.0;

  Timer? _reminderTimer;
  String? _lastShownKey;


  static const Color color1 = Color(0xFF0D2B5B);
  static const Color color2 = Color(0xFF91B3F1); 

  @override
  void initState() {
    super.initState();
    currentUser = widget.username;
    currentEmail = widget.email;
    currentPass = widget.password;


    _startReminderChecker();
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    super.dispose();
  }

  String _formatKey(DateTime date) => "${date.year}-${date.month}-${date.day}";
  String _displayLabel(DateTime date) => "${date.day}/${date.month}";

  void _startReminderChecker() {
    _reminderTimer?.cancel();

    _reminderTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      if (reminderSettings == null) return;

      final enabled = reminderSettings!["enableReminders"] == true;
      if (!enabled) return;

      final reminder = reminderSettings!["reminderTime"];
      if (reminder == null) return;

      final now = TimeOfDay.now();


      final nowKey =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-${now.hour}-${now.minute}";
      if (_lastShownKey == nowKey) return;

      final parts = reminder.toString().split(":");
      if (parts.length != 2) return;

      final rh = int.tryParse(parts[0]);
      final rm = int.tryParse(parts[1]);
      if (rh == null || rm == null) return;

      if (now.hour == rh && now.minute == rm) {
        _lastShownKey = nowKey;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("SleepEase Reminder"),
            content: const Text("Time to get ready for bed 🌙"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    });
  }

  void _applyReturnedData(dynamic result) {
    if (result == null) return;

    final map = result as Map;

    if (map["logout"] == true) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(
            updatedUser: map["username"] ?? currentUser,
            updatedEmail: map["email"] ?? currentEmail,
            updatedPass: map["password"] ?? currentPass,
          ),
        ),
      );
      return;
    }

    setState(() {
      currentUser = map["username"] ?? currentUser;
      currentEmail = map["email"] ?? currentEmail;

      if (map.containsKey("password") && map["password"] != null) {
        currentPass = map["password"];
      }

      if (map.containsKey("totalDebt") && map["totalDebt"] != null) {
        totalDebt = (map["totalDebt"] as num).toDouble();
      }
    });
  }

  Future<void> _goToLogging() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoggingPage(selectedDate: selectedDate),
      ),
    );

    if (result != null) {
      setState(() {
        dailyLogs[_formatKey(selectedDate)] = double.tryParse(result) ?? 0.0;
      });
    }
  }

  Future<void> _goToReminders() async {
    final settings = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemindersPage(initialSettings: reminderSettings),
      ),
    );

    if (settings != null) {
      setState(() {
        reminderSettings = Map<String, dynamic>.from(settings);
      });


      _startReminderChecker();
    }
  }

  Future<void> _openProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          username: currentUser,
          email: currentEmail,
          password: currentPass,
          totalDebt: totalDebt,
        ),
      ),
    );

    _applyReturnedData(result);
  }

  Future<void> _openInsights() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InsightsPage(
          username: currentUser,
          email: currentEmail,
          password: currentPass,
          totalDebt: totalDebt,
        ),
      ),
    );

    _applyReturnedData(result);
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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


  Widget _buildReminderSummary() {
    if (reminderSettings == null) {
      return Text(
        "Not set yet.",
        style: TextStyle(color: color1.withOpacity(0.65)),
      );
    }

    final enabled = reminderSettings!["enableReminders"] == true;
    final sound = reminderSettings!["soundNotification"] == true;
    final preferred = reminderSettings!["preferredBedtime"] ?? "--:--";
    final reminder = reminderSettings!["reminderTime"] ?? "--:--";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preferred bedtime: $preferred",
          style: TextStyle(color: color1.withOpacity(0.8)),
        ),
        const SizedBox(height: 6),
        Text(
          "Reminder time: ${enabled ? reminder : "Off"}",
          style: TextStyle(color: color1.withOpacity(0.8)),
        ),
        const SizedBox(height: 6),
        Text(
          "Sound: ${enabled ? (sound ? "On" : "Off") : "Off"}",
          style: TextStyle(color: color1.withOpacity(0.8)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    totalDebt = 0.0;
    for (final entry in dailyLogs.entries) {
      final dayDebt = sleepTarget - entry.value;
      if (dayDebt > 0) totalDebt += dayDebt;
    }

    return Scaffold(
      backgroundColor: color2,
      appBar: AppBar(
        title: const Text('SleepEase'),
        backgroundColor: color1,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $currentUser",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color1,
              ),
            ),
            const SizedBox(height: 18),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Day to Log',
                    style: TextStyle(
                      color: color1.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDateSelector(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Sleep Debt Status',
                    style: TextStyle(
                      color: color1.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTotalDebtMeter(totalDebt),
                ],
              ),
            ),

            const SizedBox(height: 20),

   
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Advice',
                    style: TextStyle(
                      color: color1.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildAdviceCard(totalDebt),
                ],
              ),
            ),

            const SizedBox(height: 20),

     
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminder',
                    style: TextStyle(
                      color: color1.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildReminderSummary(),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 240,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _goToLogging,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Add Sleep Log',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: 240,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _goToReminders,
                      icon: const Icon(Icons.notifications_active),
                      label: const Text('Set Bedtime Reminder'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color1,
                        side: BorderSide(color: color1.withOpacity(0.35)),
                        backgroundColor: Colors.white.withOpacity(0.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: color1,
        unselectedItemColor: color1.withOpacity(0.5),
        onTap: (index) async {
          if (index == 1) {
            await _openProfile();
          } else if (index == 2) {
            await _openInsights();
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: nextSevenDays.length,
        itemBuilder: (context, index) {
          final date = nextSevenDays[index];
          final key = _formatKey(date);

          final isSelected =
              date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;

          final hasData = dailyLogs.containsKey(key);

          return GestureDetector(
            onTap: () => setState(() => selectedDate = date),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? color1 : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _displayLabel(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (hasData)
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.check_circle,
                          size: 18, color: Colors.green),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalDebtMeter(double debt) {
    Color color = Colors.green[100]!;
    String status = "Balanced";

    if (debt > 0 && debt <= 5) {
      color = Colors.orange[100]!;
      status = "Moderate Debt: ${debt.toStringAsFixed(1)} hrs";
    } else if (debt > 5) {
      color = Colors.red[100]!;
      status = "High Debt: ${debt.toStringAsFixed(1)} hrs";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildAdviceCard(double debt) {
    final tip = debt <= 0
        ? "Your schedule is healthy. Keep maintaining this pace."
        : "You've missed ${debt.toStringAsFixed(1)} hours of rest. Consider sleeping earlier.";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tip,
        style: const TextStyle(fontSize: 15, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: color1),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
