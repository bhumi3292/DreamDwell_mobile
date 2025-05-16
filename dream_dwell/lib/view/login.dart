import 'package:flutter/material.dart';
import 'package:dream_dwell/model/login_auth.dart';
import 'dashboard.dart';
import 'package:dream_dwell/features/splash_screen/presentation/widgets/snackbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedStakeholder;
  final List<String> stakeholders = ['Tenants', 'Landlord'];
  final Color navyBlue = const Color(0xFF003366);
  String? errorMessage;

  // ------------- password visibility------
  bool _passwordVisible = false;

  //------------username password handelling

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final isAuthenticated = LoginAuth.authenticate(
        email: email,
        password: password,
        stakeholder: selectedStakeholder,
      );

      if (isAuthenticated) {
        showMySnackbar(
          context: context,
          content: 'Login successful!',
          isSuccess: true,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } else {
        showMySnackbar(
          context: context,
          content: '⚠️ Invalid credentials or missing stakeholder.',
          isSuccess: false,
        );
      }
    }
  }


  //-------------design-----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset("assets/images/logo.png", height: 80),
                const SizedBox(height: 20),
                Text(
                  "DreamDwell",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: navyBlue,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                const Text("Welcome back!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 30),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration("E-mail", Icons.email_outlined),
                  validator: (value) => value!.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 15),

                // Password Field with Toggle
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter your password' : null,
                ),
                const SizedBox(height: 15),

                // Stakeholder Dropdown
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Stake Holder", Icons.person_outline),
                  value: selectedStakeholder,
                  items: stakeholders.map((stakeholder) {
                    return DropdownMenuItem(
                      value: stakeholder,
                      child: Text(stakeholder),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStakeholder = value;
                    });
                  },
                  validator: (value) => value == null ? 'Select a role' : null,
                ),
                const SizedBox(height: 25),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navyBlue,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),

                if (errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 14)),
                ],

                const SizedBox(height: 10),

                // Forgot Password
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forget');
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: navyBlue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // Signup Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text(
                        "Signup",
                        style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.center,
                    child: Text(
                      "Connect with us",
                      style: TextStyle(color: navyBlue, fontWeight: FontWeight.w600),

                    ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset("assets/images/fb.png", height: 30,),
                    Image.asset("assets/images/google.png",height: 30),

                  ],
                )




              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
