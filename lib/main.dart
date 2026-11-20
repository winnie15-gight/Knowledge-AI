import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KnowledgeAiApp());
}

class KnowledgeAiApp extends StatelessWidget {
  const KnowledgeAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KNOWLEDGE AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        primaryColor: AppColors.accent,
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xEB0B1220),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 16),
          iconTheme: IconThemeData(color: AppColors.text),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBg,
          labelStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
          hintStyle: const TextStyle(color: Color(0xFF5A6E85), fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: AppColors.line)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: AppColors.line)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: AppColors.accent)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: const Color(0xFF09252B),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
