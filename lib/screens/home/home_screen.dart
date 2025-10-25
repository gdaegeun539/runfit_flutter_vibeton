import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/simple_auth_provider.dart';

/// 메인 홈 화면
/// 익명 사용자로 바로 사용 가능 (Phase 2에서 본격적으로 구현 예정)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run-Fit'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Consumer<SimpleAuthProvider>(
        builder: (context, authProvider, child) {
          final userModel = authProvider.userModel;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 환영 메시지
                  const Icon(
                    Icons.directions_run,
                    size: 100,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '환영합니다! 🎉',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Run-Fit과 함께 러닝을 시작하세요!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // 사용자 정보 카드
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '내 정보',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            context,
                            Icons.person,
                            '사용자 ID',
                            authProvider.userId?.substring(0, 8) ?? '로딩 중...',
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            Icons.monetization_on,
                            '건강 코인',
                            '${userModel?.totalCoin ?? 0} 코인',
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            Icons.local_fire_department,
                            '연속 스트릭',
                            '${userModel?.currentStreak ?? 0}일',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 안내 메시지
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Phase 2에서 메인 대시보드와 러닝 기능이 추가될 예정입니다.',
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4CAF50)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
