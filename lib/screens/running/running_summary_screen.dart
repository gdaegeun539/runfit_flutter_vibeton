import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

/// 러닝 요약 화면 (Task 11)
/// F-03: 러닝 요약 화면
/// 총 시간, 총 거리, 획득한 건강 코인을 표시
class RunningSummaryScreen extends StatefulWidget {
  final int elapsedSeconds;
  final double distanceKm;
  final int earnedCoins;

  const RunningSummaryScreen({
    super.key,
    required this.elapsedSeconds,
    required this.distanceKm,
    required this.earnedCoins,
  });

  @override
  State<RunningSummaryScreen> createState() => _RunningSummaryScreenState();
}

class _RunningSummaryScreenState extends State<RunningSummaryScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 축하 효과 컨트롤러
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // 애니메이션 컨트롤러
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // 화면 진입 시 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 300), () {
      _confettiController.play();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  String _getEncouragementMessage() {
    if (widget.distanceKm >= 5) {
      return '정말 대단해요! 🏆';
    } else if (widget.distanceKm >= 3) {
      return '훌륭한 러닝이었어요! 💪';
    } else if (widget.distanceKm >= 1) {
      return '잘하셨어요! 👏';
    } else {
      return '좋은 시작이에요! 🎉';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '러닝 완료!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // 메인 콘텐츠
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // 축하 메시지
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF4CAF50,
                                ).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.emoji_events,
                                size: 80,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _getEncouragementMessage(),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '오늘도 건강한 하루를 보내셨네요',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 통계 카드들
                      _buildStatCard(
                        icon: Icons.timer,
                        label: '총 시간',
                        value: _formatTime(widget.elapsedSeconds),
                        color: const Color(0xFF4CAF50),
                      ),

                      const SizedBox(height: 16),

                      _buildStatCard(
                        icon: Icons.straighten,
                        label: '총 거리',
                        value: widget.distanceKm < 1
                            ? '${(widget.distanceKm * 1000).toStringAsFixed(0)}m'
                            : '${widget.distanceKm.toStringAsFixed(2)} km',
                        color: Colors.blue,
                      ),

                      const SizedBox(height: 16),

                      _buildStatCard(
                        icon: Icons.monetization_on,
                        label: '획득한 건강 코인',
                        value: '+${widget.earnedCoins}',
                        color: const Color(0xFFFFA726),
                        isHighlight: true,
                      ),

                      const SizedBox(height: 32),

                      // 추가 정보
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[700]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '평균 속도: ${_calculateAveragePace()} km/h',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 홈으로 돌아가기 버튼
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // 러닝 화면과 요약 화면 모두 닫고 홈으로
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            '홈으로 돌아가기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 축하 효과 (Confetti)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.3,
              colors: const [
                Color(0xFF4CAF50),
                Color(0xFFFFA726),
                Colors.blue,
                Colors.red,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isHighlight ? color.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlight ? color : Colors.grey[300]!,
          width: isHighlight ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAveragePace() {
    if (widget.elapsedSeconds == 0) return '0.0';
    final hours = widget.elapsedSeconds / 3600;
    final avgSpeed = widget.distanceKm / hours;
    return avgSpeed.toStringAsFixed(1);
  }
}
