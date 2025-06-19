import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupViewModel extends ChangeNotifier {
  // Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // State
  String? selectedStakeholder;
  String? errorMessage;
  bool isLoading = false;

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  final List<String> stakeholders = ['Tenants', 'Landlord'];

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }

  void selectStakeholder(String? value) {
    selectedStakeholder = value;
    notifyListeners();
  }

  // Validation logic separated
  String? validateFullName(String? value) =>
      (value == null || value.isEmpty) ? 'Enter your name' : null;

  String? validateEmail(String? value) =>
      (value == null || value.isEmpty) ? 'Enter your email' : null;

  String? validatePhone(String? value) =>
      (value == null || value.isEmpty) ? 'Enter your phone' : null;

  String? validateStakeholder(String? value) =>
      (value == null || value.isEmpty) ? 'Select a role' : null;

  String? validatePassword(String? value) =>
      (value == null || value.isEmpty) ? 'Enter a password' : null;

  String? validateConfirmPassword(String? value) =>
      (value == null || value.isEmpty) ? 'Confirm your password' : null;

  bool passwordsMatch() =>
      passwordController.text == confirmPasswordController.text;

  Future<bool> submit() async {
    errorMessage = null;

    if (!passwordsMatch()) {
      errorMessage = '⚠️ Passwords do not match.';
      notifyListeners();
      return false;
    }

    // Additional signup logic (e.g., API call) here
    // Simulate loading
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulate network call

    isLoading = false;
    notifyListeners();

    return true;
  }

  void disposeControllers() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final SignupViewModel viewModel = SignupViewModel();

  final Color navyBlue = const Color(0xFF003366);

  @override
  void dispose() {
    viewModel.disposeControllers();
    super.dispose();
  }

  void _onSignupPressed() {
    if (_formKey.currentState!.validate()) {
      if (viewModel.passwordController.text != viewModel.confirmPasswordController.text) {
        setState(() {
          viewModel.errorMessage = '⚠️ Passwords do not match.';
        });
        return;
      }

      final bloc = context.read<RegisterUserViewModel>();

      bloc.add(RegisterNewUserEvent(
        fullName: viewModel.fullNameController.text.trim(),
        email: viewModel.emailController.text.trim(),
        phone: viewModel.phoneController.text.trim(),
        stakeholder: viewModel.selectedStakeholder!,
        password: viewModel.passwordController.text,
        confirmPassword: viewModel.confirmPasswordController.text,
        context: context,
      ));
    }
  }


  InputDecoration _inputDecoration(String label, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: AnimatedBuilder(
            animation: viewModel,
            builder: (context, _) => Form(
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
                  const Text(
                    "Create your account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 30),

                  // Full Name
                  TextFormField(
                    controller: viewModel.fullNameController,
                    decoration: _inputDecoration("Full Name", Icons.person_outline),
                    validator: viewModel.validateFullName,
                  ),
                  const SizedBox(height: 15),

                  // Email
                  TextFormField(
                    controller: viewModel.emailController,
                    decoration: _inputDecoration("E-mail", Icons.email_outlined),
                    validator: viewModel.validateEmail,
                  ),
                  const SizedBox(height: 15),

                  // Phone
                  TextFormField(
                    controller: viewModel.phoneController,
                    decoration: _inputDecoration("Phone", Icons.phone),
                    keyboardType: TextInputType.phone,
                    validator: viewModel.validatePhone,
                  ),
                  const SizedBox(height: 15),

                  // Stakeholder Dropdown
                  DropdownButtonFormField<String>(
                    value: viewModel.selectedStakeholder,
                    decoration: _inputDecoration("Stake Holder", Icons.person_pin),
                    items: viewModel.stakeholders.map((stakeholder) {
                      return DropdownMenuItem(
                        value: stakeholder,
                        child: Text(stakeholder),
                      );
                    }).toList(),
                    onChanged: viewModel.selectStakeholder,
                    validator: viewModel.validateStakeholder,
                  ),
                  const SizedBox(height: 15),

                  // Password
                  TextFormField(
                    controller: viewModel.passwordController,
                    obscureText: !viewModel.passwordVisible,
                    decoration: _inputDecoration(
                      "Password",
                      Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.passwordVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: viewModel.togglePasswordVisibility,
                      ),
                    ),
                    validator: viewModel.validatePassword,
                  ),
                  const SizedBox(height: 15),

                  // Confirm Password
                  TextFormField(
                    controller: viewModel.confirmPasswordController,
                    obscureText: !viewModel.confirmPasswordVisible,
                    decoration: _inputDecoration(
                      "Confirm Password",
                      Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.confirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: viewModel.toggleConfirmPasswordVisibility,
                      ),
                    ),
                    validator: viewModel.validateConfirmPassword,
                  ),
                  const SizedBox(height: 20),

                  if (viewModel.errorMessage != null) ...[
                    Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                  ],

                  viewModel.isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _onSignupPressed,
                      child: const Text(
                        "Signup",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Login Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: navyBlue,
                            fontWeight: FontWeight.bold,
                          ),
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
                      Image.asset("assets/images/fb.png", height: 30),
                      const SizedBox(width: 10),
                      Image.asset("assets/images/google.png", height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
