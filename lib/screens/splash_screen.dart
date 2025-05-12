import 'package:flutter/material.dart';
import 'package:prac8/screens/home_page.dart';
import 'package:prac8/services/auth_service.dart';
import 'package:prac8/auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  void _checkUserLoggedIn() async {
    await Future.delayed(const Duration(seconds: 2));
    if (_authService.isUserLoggedIn()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.teal,
            ),
            SizedBox(height: 20),
            Text(
              'Todo App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
