import 'package:flutter/material.dart';
// Firebase 패키지 (flutterfire configure 완료 후 주석 해제)
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  // Firebase 초기화 (flutterfire configure 완료 후 주석 해제)
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const RunFitApp());
}

class RunFitApp extends StatelessWidget {
  const RunFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run-Fit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50), // 러닝을 상징하는 그린 컬러
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Pretendard', // 추후 폰트 추가 시 사용
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_run, size: 120, color: Colors.white),
              const SizedBox(height: 24),
              Text(
                'Run-Fit',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '초보 러너를 위한 간편한 러닝 앱',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
