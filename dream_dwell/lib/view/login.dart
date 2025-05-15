import 'package:flutter/material.dart';
import 'package:dream_dwell/model/login_auth.dart';
import 'dashboard.dart'; // make sure you have this file created

class Login extends StatefulWidget {
  final String title;

  const Login({super.key, required this.title});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? selectedStakeholder;
  final List<String> stakeholders = ['Tenants', 'Landlord'];
  final Color navyBlue = const Color(0xFF003366);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? errorMessage;

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final isAuthenticated = LoginAuth.authenticate(
      email: email,
      password: password,
      stakeholder: selectedStakeholder,
    );
//------------Authintacated----------
    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } else {
      setState(() {
        errorMessage = 'Invalid credentials or missing stakeholder';
      });
    }
  }

  //--------design--------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png", height: 80),
                const SizedBox(height: 20),
                Text(
                  "DreamDwell",
                  style: TextStyle(

                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: navyBlue,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Welcome back!!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Stake Holder",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navyBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _handleLogin,
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'forget');
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: navyBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'signup');
                      },
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          color: navyBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
