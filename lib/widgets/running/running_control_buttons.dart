import 'package:flutter/material.dart';

/// 러닝 컨트롤 버튼 위젯
/// 일시정지, 재개, 종료 버튼을 제공
class RunningControlButtons extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onFinish;

  const RunningControlButtons({
    super.key,
    required this.isRunning,
    required this.onPause,
    required this.onResume,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // 일시정지/재개 버튼
          Expanded(
            flex: 2,
            child: _ControlButton(
              icon: isRunning ? Icons.pause : Icons.play_arrow,
              label: isRunning ? '일시정지' : '재개',
              color: isRunning ? Colors.orange : const Color(0xFF4CAF50),
              onPressed: isRunning ? onPause : onResume,
            ),
          ),
          const SizedBox(width: 16),

          // 종료 버튼
          Expanded(
            child: _ControlButton(
              icon: Icons.stop,
              label: '종료',
              color: Colors.red,
              onPressed: onFinish,
            ),
          ),
        ],
      ),
    );
  }
}

/// 개별 컨트롤 버튼
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
