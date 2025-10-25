import 'package:flutter/material.dart';

/// 러닝 시작 버튼 위젯
/// 메인 대시보드 중앙의 크고 직관적인 버튼 (F-01)
class StartRunningButton extends StatefulWidget {
  final VoidCallback onPressed;

  const StartRunningButton({super.key, required this.onPressed});

  @override
  State<StartRunningButton> createState() => _StartRunningButtonState();
}

class _StartRunningButtonState extends State<StartRunningButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 러닝 아이콘
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_run,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // 버튼 텍스트
                Text(
                  '러닝 시작하기',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // 서브 텍스트
                Text(
                  '탭하여 운동을 시작하세요',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
