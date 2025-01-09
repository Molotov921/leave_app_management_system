import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'screens/admin/admin_home.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/interns/intern_home.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ),
    initialRoute: '/',
    builder: (context, child) {
      Get.put(AuthController());
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF241B61),
              Color(0xFF3C5BCC),
              Color(0xFF4B0082),
              Color(0xFF6A0DAD),
            ],
          ),
        ),
        child: child,
      );
    },
    getPages: [
      GetPage(name: '/', page: () => const SplashScreen()),
      GetPage(name: '/login', page: () => const LoginScreen()),
      GetPage(name: '/signup', page: () => const RegisterScreen()),
      GetPage(name: '/adminDashboard', page: () => const AdminHome()),
      GetPage(name: '/internDashboard', page: () => const InternDashboard()),
    ],
  ));
}
