import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/secure_storage.dart';
import 'auth/login_screen.dart';
import 'chat/chat_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final token = await SecureStorage.getAccessToken();
    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('✦', style: TextStyle(fontSize: 48, color: AppColors.accent)),
            SizedBox(height: 16),
            Text(
              'KNOWLEDGE AI',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text, letterSpacing: 1.5),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2.5),
          ],
        ),
      ),
    );
  }
}
