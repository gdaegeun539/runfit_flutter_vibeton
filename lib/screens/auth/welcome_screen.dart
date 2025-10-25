import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/simple_auth_provider.dart';

/// 환영 화면 (더미 로그인 화면)
/// 버튼 클릭 시 바로 메인 화면으로 이동
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF4CAF50),
              const Color(0xFF4CAF50).withValues(alpha: 0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 앱 로고
                  const Icon(
                    Icons.directions_run,
                    size: 120,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 32),

                  // 앱 타이틀
                  Text(
                    'Run-Fit',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // 서브 타이틀
                  Text(
                    '초보 러너를 위한 간편한 러닝 앱',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),

                  // 시작하기 버튼
                  Consumer<SimpleAuthProvider>(
                    builder: (context, authProvider, child) {
                      return ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                await authProvider.startApp();
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 20,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF4CAF50),
                                ),
                              )
                            : const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '시작하기',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // 안내 문구
                  Text(
                    '별도의 로그인 없이 바로 시작할 수 있습니다',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                    textAlign: TextAlign.center,
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

