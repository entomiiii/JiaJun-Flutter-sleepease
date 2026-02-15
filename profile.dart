

import 'package:flutter/material.dart';
import 'about.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String password;
  final double totalDebt;

  const ProfilePage({
    super.key,
    required this.username,
    required this.email,
    required this.password,
    required this.totalDebt,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _userController;
  late TextEditingController _emailController;

  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  static const Color color1 = Color(0xFF0D2B5B);
  static const Color color2 = Color(0xFF91B3F1);

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Map<String, dynamic> _buildReturnPayload({required bool logout}) {
    return {
      "logout": logout,
      "username": _userController.text.trim(),
      "email": _emailController.text.trim(),

      "password": _newPassController.text.isEmpty ? null : _newPassController.text,
      "totalDebt": widget.totalDebt,
    };
  }

  void _saveChanges() {
    final newUser = _userController.text.trim();
    final newEmail = _emailController.text.trim();
    final newPass = _newPassController.text;
    final confirm = _confirmPassController.text;

    if (newUser.isEmpty || newEmail.isEmpty) {
      _showMsg("Username and email cannot be empty.");
      return;
    }

    if (!newEmail.contains("@")) {
      _showMsg("Invalid email.");
      return;
    }

    if (newPass.isNotEmpty || confirm.isNotEmpty) {
      if (newPass.length < 6) {
        _showMsg("Password must be at least 6 characters.");
        return;
      }
      if (newPass != confirm) {
        _showMsg("Passwords do not match.");
        return;
      }
    }


    Navigator.pop(context, _buildReturnPayload(logout: false));
  }

  void _logout() {
    Navigator.pop(context, {
      "logout": true,
      "username": _userController.text.trim(),
      "email": _emailController.text.trim(),

      "password": widget.password,
      "totalDebt": widget.totalDebt,
    });
  }

  InputDecoration _inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: color1),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color1.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: color1, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
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

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 110, color: color1),
            const SizedBox(height: 10),
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color1),
            ),
            const SizedBox(height: 18),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Username",
                    style: TextStyle(
                      color: color1.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _userController,
                    decoration: _inputStyle("Username", Icons.person),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "Email",
                    style: TextStyle(
                      color: color1.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputStyle("Email", Icons.email),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "New Password",
                    style: TextStyle(
                      color: color1.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newPassController,
                    obscureText: true,
                    decoration: _inputStyle("New Password", Icons.lock),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "Confirm Password",
                    style: TextStyle(
                      color: color1.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmPassController,
                    obscureText: true,
                    decoration: _inputStyle("Confirm Password", Icons.lock_outline),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: TextButton(
                      onPressed: _logout,
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700),
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
        currentIndex: 1,
        selectedItemColor: color1,
        unselectedItemColor: color1.withOpacity(0.5),
        onTap: (index) {
          if (index == 0) {

            Navigator.pop(context, _buildReturnPayload(logout: false));
          } else if (index == 2) {

            Navigator.pop(context, _buildReturnPayload(logout: false));
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: color1),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Us'),
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
}
