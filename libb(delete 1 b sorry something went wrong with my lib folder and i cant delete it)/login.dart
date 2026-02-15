
import 'package:flutter/material.dart';
import 'register.dart';
import 'Homepage.dart';

class LoginPage extends StatefulWidget {
  final String? updatedUser;
  final String? updatedEmail;
  final String? updatedPass;

  const LoginPage({
    super.key,
    this.updatedUser,
    this.updatedEmail,
    this.updatedPass,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userControl = TextEditingController();
  final TextEditingController _passControl = TextEditingController();

  String? savedUser;
  String? savedPass;
  String? savedEmail;


  static const Color color1 = Color(0xFF0D2B5B);
  static const Color color2 = Color(0xFF91B3F1);

  @override
  void initState() {
    super.initState();
    savedUser = widget.updatedUser;
    savedEmail = widget.updatedEmail;
    savedPass = widget.updatedPass;

    if (savedUser != null) {
      _userControl.text = savedUser!;
    }
  }

  @override
  void dispose() {
    _userControl.dispose();
    _passControl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_userControl.text == savedUser &&
        _passControl.text == savedPass &&
        savedUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            username: savedUser!,
            email: savedEmail ?? "No email provided",
            password: savedPass ?? "",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  Future<void> _goToRegister() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );

    if (result != null && mounted) {
      setState(() {
        savedUser = result['user'];
        savedPass = result['pass'];
        savedEmail = result['email'];

        _userControl.text = savedUser ?? "";
        _passControl.clear();
      });

     
    }
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
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Image.asset(
                "images/logo.png",
                height: 180,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 25),


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
                    Text(
                      'Username',
                      style: TextStyle(
                        color: color1.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _userControl,
                      decoration: _inputStyle("Enter username", Icons.person),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Password',
                      style: TextStyle(
                        color: color1.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passControl,
                      obscureText: true,
                      decoration: _inputStyle("Enter password", Icons.lock),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:color1,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child: TextButton(
                        onPressed: _goToRegister,
                        child: Text(
                          'New user? Register here',
                          style: TextStyle(
                            color: color1,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
