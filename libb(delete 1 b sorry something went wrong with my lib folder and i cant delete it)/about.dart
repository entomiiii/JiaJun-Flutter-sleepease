import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color color1 = Color(0xFF0D2B5B); // navy
  static const Color color2 = Color(0xFF91B3F1); // logo background

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color2, // ✅ solid background
      appBar: AppBar(
        title: const Text('SleepEase'),
        backgroundColor: color1,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 10),

            Image.asset(
              "images/logo.png",
              height: 200,
            ),

            const SizedBox(height: 14),

            const Text(
              "About SleepEase",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color1,
              ),
            ),

            const SizedBox(height: 6),

            
            const SizedBox(height: 30),

            const _InfoCard(
              icon: Icons.apps,
              title: "Application",
              content:
                  "SleepEase is a sleep tracking and insight application "
                  "that helps users monitor sleep duration, understand sleep "
                  "debt, and improve bedtime habits using logs, reminders, "
                  "and personalized insights.",
            ),

            const SizedBox(height: 20),

            const _InfoCard(
              icon: Icons.business,
              title: "Company",
              content:
                  "SleepEase Labs\n"
                  "1240 SouthWest ExpressWay",
            ),

            const SizedBox(height: 20),

            const _InfoCard(
              icon: Icons.person,
              title: "Developer",
              content: "Developed by: Ren JiaJun",
            ),

            const SizedBox(height: 20),

            const _InfoCard(
              icon: Icons.contact_mail,
              title: "Contact Information",
              content:
                  "Phone: +65 1234 5678\n"
                  "Email: support@sleepease.app",
            ),
          ],
        ),
      ),
    );
  }
}



class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xFF0D2B5B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF91B3F1).withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color1),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
