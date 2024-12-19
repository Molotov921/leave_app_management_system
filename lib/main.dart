import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/interns/intern_dashboard.dart';
import 'screens/intro/intro_screen.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leave Management System',
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
        GetPage(name: '/intro', page: () => const IntroScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/adminDashboard', page: () => const AdminDashboard()),
        GetPage(name: '/internDashboard', page: () => const InternDashboard()),
        GetPage(name: '/signup', page: () => const RegisterScreen()),
      ],
    );
  }
}
