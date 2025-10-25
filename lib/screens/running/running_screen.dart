import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/running_provider.dart';
import '../../widgets/running/running_stat_display.dart';
import '../../widgets/running/running_control_buttons.dart';

/// 러닝 중 화면 (Task 8)
/// F-02: 인터벌 음성 코칭 화면
/// 총 시간, 거리, 속도를 표시하고 일시정지/종료 기능 제공
class RunningScreen extends StatefulWidget {
  const RunningScreen({super.key});

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 러닝 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRunning();
    });
  }

  Future<void> _startRunning() async {
    final provider = context.read<RunningProvider>();
    try {
      await provider.startRunning();
    } catch (e) {
      if (!mounted) return;
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('위치 권한 필요'),
        content: const Text(
          '러닝 거리를 측정하려면 위치 권한이 필요합니다.\n'
          '설정에서 위치 권한을 허용해주세요.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // 러닝 화면도 닫기
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startRunning(); // 재시도
            },
            child: const Text('재시도'),
          ),
        ],
      ),
    );
  }

  void _handleFinish() {
    final provider = context.read<RunningProvider>();

    // 러닝 시간이 너무 짧으면 경고
    if (provider.elapsedSeconds < 10) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('러닝 종료'),
          content: const Text('러닝 시간이 너무 짧습니다. 정말 종료하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _finishRunning();
              },
              child: const Text('종료', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      return;
    }

    _finishRunning();
  }

  void _finishRunning() {
    final provider = context.read<RunningProvider>();
    provider.finishRunning();

    // TODO: Task 11에서 러닝 요약 화면으로 이동
    // 지금은 임시로 홈으로 돌아감
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '러닝 완료! ${provider.formattedTime}, ${provider.formattedDistance}',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // 뒤로가기 버튼 누를 때 확인
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('러닝 종료'),
            content: const Text('러닝을 종료하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('종료', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            '러닝 중',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('러닝 종료'),
                  content: const Text('러닝을 종료하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        '종료',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
              if (shouldPop == true && mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Consumer<RunningProvider>(
          builder: (context, provider, child) {
            final isRunning = provider.state == RunningState.running;

            return SafeArea(
              child: Column(
                children: [
                  // 상단 배경 영역
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.only(bottom: 24, top: 16),
                    child: Column(
                      children: [
                        // 상태 표시
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isRunning
                                    ? Icons.directions_run
                                    : Icons.pause_circle_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isRunning ? '실행 중' : '일시정지',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 통계 영역
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),

                          // 총 시간 (메인)
                          RunningStatDisplay(
                            icon: Icons.timer,
                            label: '총 시간',
                            value: provider.formattedTime,
                            color: const Color(0xFF4CAF50),
                          ),

                          // 거리와 속도 (2열)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                RunningStatCard(
                                  icon: Icons.straighten,
                                  label: '거리',
                                  value: provider.formattedDistance,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 16),
                                RunningStatCard(
                                  icon: Icons.speed,
                                  label: '현재 속도',
                                  value: provider.formattedSpeed,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // 추가 정보 카드
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
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
                                _buildInfoRow(
                                  Icons.av_timer,
                                  '평균 속도',
                                  '${provider.averageSpeed.toStringAsFixed(1)} km/h',
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  Icons.access_time,
                                  '시작 시간',
                                  provider.startTime != null
                                      ? '${provider.startTime!.hour.toString().padLeft(2, '0')}:${provider.startTime!.minute.toString().padLeft(2, '0')}'
                                      : '--:--',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  // 컨트롤 버튼
                  RunningControlButtons(
                    isRunning: isRunning,
                    onPause: () => provider.pauseRunning(),
                    onResume: () => provider.resumeRunning(),
                    onFinish: _handleFinish,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
