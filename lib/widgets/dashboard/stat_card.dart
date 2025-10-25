import 'package:flutter/material.dart';

/// 대시보드 통계 카드 위젯
/// 코인, 스트릭 등의 통계 정보를 표시하는 재사용 가능한 카드
class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color? backgroundColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor ?? color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),

            // 값
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),

            // 라벨
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
