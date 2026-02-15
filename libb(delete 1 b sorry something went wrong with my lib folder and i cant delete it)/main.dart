import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(const SleepEaseApp());

class SleepEaseApp extends StatelessWidget {
  const SleepEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), 
    );
  }
}