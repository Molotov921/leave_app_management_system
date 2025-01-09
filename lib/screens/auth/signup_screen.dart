import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool isPasswordVisible = false;

  void registerIntern() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = await authService.registerIntern(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );

      if (user != null) {
        // Storing user data with the role 'intern' in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': 'intern', // Storing the role as 'intern'
        });

        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildTextField({
    required String labelText,
    required TextEditingController controller,
    bool obscureText = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.white) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, color: Colors.white),
                onPressed: onSuffixIconPressed,
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Dismiss keyboard when tapping outside
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: MediaQuery.of(context).size.width * 0.6,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 40),
                  buildTextField(
                    labelText: 'Name',
                    controller: nameController,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    labelText: 'Email',
                    controller: emailController,
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    labelText: 'Password',
                    controller: passwordController,
                    prefixIcon: Icons.lock,
                    obscureText: !isPasswordVisible,
                    suffixIcon: isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSuffixIconPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: registerIntern,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A0DAD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 16,
                            ),
                            elevation: 10,
                            shadowColor:
                                const Color(0xFF3C5BCC).withValues(alpha: 0.5),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    child: const Text(
                      'Already have an account? Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
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
