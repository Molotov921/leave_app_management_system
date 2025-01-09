import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_services.dart';
import 'admin_dashboard.dart';
import 'leave_details.dart';
import 'leave_request.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const AdminDashboardContent(),
    const LeaveRequests(),
    const LeaveDetails(),
  ];

  final List<String> _titles = [
    "Admin Dashboard",
    "Leave Requests",
    "Leave Details",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    void logout() async {
      await authService.signOut();
      Get.offAllNamed('/login');
    }

    void showLogoutDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: const Color(0xFF241B61),
            contentPadding: const EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  "Are you sure you want to log out?",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  logout();
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: showLogoutDialog,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color(0xFF241B61),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              items: [
                _buildBarItem(Icons.dashboard, 'Dashboard', 0),
                _buildBarItem(Icons.request_page, 'Leave Requests', 1),
                _buildBarItem(Icons.history, 'Leave Details', 2),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBarItem(
      IconData icon, String label, int index) {
    final isSelected = index == _selectedIndex;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
      label: label,
    );
  }
}
