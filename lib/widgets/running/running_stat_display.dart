import 'package:flutter/material.dart';

/// 러닝 통계 디스플레이 위젯
/// 시간, 거리, 속도 등을 크게 표시
class RunningStatDisplay extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const RunningStatDisplay({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // 아이콘
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),

          // 값 (큰 텍스트)
          Text(
            value,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),

          // 라벨
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// 작은 통계 카드 (2개를 가로로 배치할 때 사용)
class RunningStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const RunningStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
