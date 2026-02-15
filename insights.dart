
import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'profile.dart';
import 'about.dart';

class InsightsPage extends StatefulWidget {
  final String username;
  final String email;
  final String password;
  final double totalDebt;

  const InsightsPage({
    super.key,
    required this.username,
    required this.email,
    required this.password,
    required this.totalDebt,
  });

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  static const Color color1 = Color(0xFF0D2B5B);
  static const Color color2 = Color(0xFF91B3F1);

  late String username;
  late String email;
  late String password;
  late double totalDebt;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    email = widget.email;
    password = widget.password;
    totalDebt = widget.totalDebt;
  }

  void _applyReturnedData(dynamic result) {
    if (result == null) return;

    final map = result as Map;

    if (map["logout"] == true) {
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }

    setState(() {
      username = map["username"] ?? username;
      email = map["email"] ?? email;

      if (map.containsKey("password") && map["password"] != null) {
        password = map["password"];
      }

      if (map.containsKey("totalDebt") && map["totalDebt"] != null) {
        totalDebt = (map["totalDebt"] as num).toDouble();
      }
    });
  }

  Future<void> _goHome() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          username: username,
          email: email,
          password: password,
        ),
      ),
    );
    _applyReturnedData(result);
  }

  Future<void> _goProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePage(
          username: username,
          email: email,
          password: password,
          totalDebt: totalDebt,
        ),
      ),
    );
    _applyReturnedData(result);
  }

  @override
  Widget build(BuildContext context) {
    final debt = totalDebt;

    String level = "Balanced";
    if (debt > 0 && debt <= 5) level = "Moderate";
    if (debt > 5) level = "High";

    final List<_InsightModel> cards = _buildCards(debt, level);

    final List<Widget> widgets = [];
    for (int i = 0; i < cards.length; i++) {
      widgets.add(_InsightCard(model: cards[i]));
      if (i != cards.length - 1) widgets.add(const SizedBox(height: 18));
    }

    return Scaffold(
      backgroundColor: color2,
      appBar: AppBar(
        title: const Text("SleepEase"),
        backgroundColor: color1,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Weekly Sleep Insights",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "User: $username",
              style: TextStyle(color: color1.withOpacity(0.7)),
            ),
            const SizedBox(height: 14),
            ...widgets,
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: color1,
        unselectedItemColor: color1.withOpacity(0.6),
        onTap: (index) async {
          if (index == 0) {
            await _goHome();
          } else if (index == 1) {
            await _goProfile();
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: "Insights"),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: color1),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About Us"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  List<_InsightModel> _buildCards(double debt, String level) {
    final blue = Colors.blue[100];
    final green = Colors.green[100];
    final yellow = Colors.yellow[100];
    final purple = Colors.purple[100];

    if (level == "Balanced") {
      return [
        _InsightModel(
          title: "Common Pattern: Stable Schedule",
          body:
              "Your sleep debt is balanced.\nYou’re keeping up with your sleep target well.",
          bg: blue,
          titleColor: Colors.blue[900],
          bodyColor: Colors.blue[900],
        ),
        _InsightModel(
          title: "Consistent Sleep Duration",
          body:
              "Your recent sleep duration meets your needs.\nTry to keep this consistency daily.",
          bg: green,
          titleColor: Colors.green[900],
          bodyColor: Colors.green[900],
        ),
        _InsightModel(
          title: "Weekend Catch-up",
          body:
              "You don’t need heavy weekend catch-up.\nKeep weekends steady to protect your rhythm.",
          bg: yellow,
          titleColor: Colors.orange[900],
          bodyColor: Colors.orange[900],
        ),
        _InsightModel(
          title: "Recommendation:",
          body: "Maintain your routine. If you want more rest, sleep for 9 hours.",
          bg: purple,
          titleColor: Colors.purple[900],
          bodyColor: Colors.purple[900],
        ),
      ];
    }

    if (level == "Moderate") {
      return [
        _InsightModel(
          title: "Common Pattern: Sleep Debt Building",
          body:
              "Your total sleep debt is ${debt.toStringAsFixed(1)} hours.\nA few shorter nights may be adding up.",
          bg: blue,
          titleColor: Colors.blue[900],
          bodyColor: Colors.blue[900],
        ),
        _InsightModel(
          title: "Consistency Check",
          body:
              "Your sleep is somewhat consistent, but slightly under target.\nSmall improvements will reduce debt.",
          bg: green,
          titleColor: Colors.green[900],
          bodyColor: Colors.green[900],
        ),
        _InsightModel(
          title: "Weekend Catch-up Risk",
          body:
              "You may feel tempted to oversleep on weekends.\nLarge weekend catch-up can disrupt weekdays.",
          bg: yellow,
          titleColor: Colors.orange[900],
          bodyColor: Colors.orange[900],
        ),
        _InsightModel(
          title: "Recommendation:",
          body:
              "Try sleeping 15–30 minutes earlier for the next few weekdays.\nThat can gradually erase the debt.",
          bg: purple,
          titleColor: Colors.purple[900],
          bodyColor: Colors.purple[900],
        ),
      ];
    }

    return [
      _InsightModel(
        title: "Common Pattern: High Sleep Debt",
        body:
            "Your total sleep debt is ${debt.toStringAsFixed(1)} hours.\nThis level may affect mood, focus, and energy.",
        bg: blue,
        titleColor: Colors.blue[900],
        bodyColor: Colors.blue[900],
      ),
      _InsightModel(
        title: "Consistency Issue",
        body:
            "Your recent sleep duration is far below target.\nRecovery will take a few days of steady sleep.",
        bg: green,
        titleColor: Colors.green[900],
        bodyColor: Colors.green[900],
      ),
      _InsightModel(
        title: "Weekend Catch-up Warning",
        body:
            "You may try to repay the debt in one weekend.\nOversleeping a lot can break your sleep schedule.",
        bg: yellow,
        titleColor: Colors.orange[900],
        bodyColor: Colors.orange[900],
      ),
      _InsightModel(
        title: "Recommendation:",
        body:
            "Aim for 30–60 minutes earlier bedtime for several nights.\nKeep wake-up time consistent for faster recovery.",
        bg: purple,
        titleColor: Colors.purple[900],
        bodyColor: Colors.purple[900],
      ),
    ];
  }
}

class _InsightModel {
  final String title;
  final String body;
  final Color? bg;
  final Color? titleColor;
  final Color? bodyColor;

  _InsightModel({
    required this.title,
    required this.body,
    required this.bg,
    required this.titleColor,
    required this.bodyColor,
  });
}

class _InsightCard extends StatelessWidget {
  final _InsightModel model;

  const _InsightCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: model.bg ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: model.titleColor ?? Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            model.body,
            style: TextStyle(
              height: 1.35,
              color: model.bodyColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
