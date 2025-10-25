import 'package:flutter/material.dart';
import 'dart:math';

/// 시니어 조언 카드 위젯 (C-01)
/// 러닝 관련 팁을 랜덤으로 표시하는 카드
class AdviceCard extends StatefulWidget {
  const AdviceCard({super.key});

  @override
  State<AdviceCard> createState() => _AdviceCardState();
}

class _AdviceCardState extends State<AdviceCard> {
  // 하드코딩된 시니어 조언 리스트
  static const List<Map<String, String>> _adviceList = [
    {
      'title': '준비운동은 필수입니다',
      'content': '러닝 전 5분간 스트레칭으로 부상을 예방하세요. 특히 종아리와 허벅지를 충분히 풀어주세요.',
    },
    {
      'title': '천천히 시작하세요',
      'content': '처음부터 무리하지 마세요. 걷기와 뛰기를 번갈아 하면서 체력을 키워나가는 것이 중요합니다.',
    },
    {
      'title': '수분 섭취를 잊지 마세요',
      'content': '러닝 전후로 충분한 물을 마시세요. 탈수는 운동 효율을 떨어뜨리고 부상 위험을 높입니다.',
    },
    {
      'title': '올바른 자세가 중요합니다',
      'content': '상체를 곧게 펴고 시선은 전방 10m를 바라보세요. 팔은 자연스럽게 흔들며 발은 뒤꿈치부터 착지하세요.',
    },
    {
      'title': '꾸준함이 핵심입니다',
      'content': '일주일에 3-4회, 20-30분씩 꾸준히 하는 것이 한 번에 오래 하는 것보다 효과적입니다.',
    },
    {
      'title': '적절한 신발을 착용하세요',
      'content': '러닝화는 발의 충격을 흡수해주는 중요한 장비입니다. 발에 잘 맞는 러닝화를 선택하세요.',
    },
  ];

  late Map<String, String> _currentAdvice;

  @override
  void initState() {
    super.initState();
    _selectRandomAdvice();
  }

  void _selectRandomAdvice() {
    final random = Random();
    setState(() {
      _currentAdvice = _adviceList[random.nextInt(_adviceList.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[50]!, Colors.blue[100]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '💡 시니어 조언',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: _selectRandomAdvice,
                tooltip: '다른 조언 보기',
                color: Colors.blue[700],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 조언 제목
          Text(
            _currentAdvice['title']!,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 8),

          // 조언 내용
          Text(
            _currentAdvice['content']!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.blue[900],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
