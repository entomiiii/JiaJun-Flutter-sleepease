
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();


  static const Color color1 = Color(0xFF0D2B5B); 
  static const Color color2 = Color(0xFF91B3F1);

  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return regex.hasMatch(email);
  }

  void _register() {
    final user = _userController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passController.text;
    final confirm = _confirmPassController.text;

    if (user.isEmpty || email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _showMsg("Please fill in all fields.");
      return;
    }

    if (!_isValidEmail(email)) {
      _showMsg("Please enter a valid email address.");
      return;
    }

    if (pass.length < 6) {
      _showMsg("Password must be at least 6 characters.");
      return;
    }

    if (pass != confirm) {
      _showMsg("Passwords do not match.");
      return;
    }

    Navigator.pop(context, {
      'user': user,
      'email': email,
      'pass': pass,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color2,
      appBar: AppBar(
        title: const Text('SleepEase'),
        backgroundColor: color1,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Image.asset(
                "images/logo.png",
                height: 150,
              fit: BoxFit.contain
              ),


              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Create Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color1,
                        )),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _userController,
                      decoration: _inputStyle("Username", Icons.person),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputStyle("Email", Icons.email),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: _passController,
                      obscureText: true,
                      decoration: _inputStyle("Password", Icons.lock),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: _confirmPassController,
                      obscureText: true,
                      decoration:
                          _inputStyle("Confirm Password", Icons.lock_outline),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color1,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Register',
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
      ),
    );
  }
}
