import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/simple_auth_provider.dart';
import '../../providers/running_provider.dart';
import '../../widgets/dashboard/stat_card.dart';
import '../../widgets/dashboard/start_running_button.dart';
import '../../widgets/dashboard/advice_card.dart';
import '../running/running_screen.dart';
import 'package:intl/intl.dart';

/// 메인 홈 화면 - 대시보드 레이아웃 (Task 5)
/// F-01: 간편 러닝 시작
/// F-04: 건강 코인 누적 표시
/// F-05: 연속 스트릭 표시
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Run-Fit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: 설정 화면으로 이동 (Phase 3)
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('설정 기능은 곧 추가됩니다')));
            },
          ),
        ],
      ),
      body: Consumer<SimpleAuthProvider>(
        builder: (context, authProvider, child) {
          final userModel = authProvider.userModel;

          // 로딩 상태
          if (authProvider.isLoading || userModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 배경 영역
                Container(
                  color: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      // 환영 메시지
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getGreeting(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '오늘도 건강한 하루!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 통계 카드 (F-04, F-05)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            // 건강 코인 카드 (F-04)
                            StatCard(
                              icon: Icons.monetization_on,
                              label: '건강 코인',
                              value: _formatNumber(userModel.totalCoin),
                              color: const Color(0xFFFFA726),
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(width: 16),

                            // 연속 스트릭 카드 (F-05)
                            StatCard(
                              icon: Icons.local_fire_department,
                              label: '연속 스트릭',
                              value: '${userModel.currentStreak}일',
                              color: const Color(0xFFEF5350),
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 러닝 시작 버튼 (F-01)
                StartRunningButton(
                  onPressed: () {
                    // 러닝 Provider 리셋 후 러닝 화면으로 이동
                    final runningProvider = context.read<RunningProvider>();
                    runningProvider.resetSession();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RunningScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // 시니어 조언 카드 (C-01)
                const AdviceCard(),

                const SizedBox(height: 24),

                // 최근 러닝 기록 섹션 (추후 구현)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '최근 러닝 기록',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.directions_run_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '아직 러닝 기록이 없습니다',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '지금 바로 러닝을 시작해보세요!',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 시간대별 인사말
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '좋은 아침입니다';
    } else if (hour < 18) {
      return '좋은 오후입니다';
    } else {
      return '좋은 저녁입니다';
    }
  }

  /// 숫자 포맷팅 (1000 -> 1,000)
  String _formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
}
