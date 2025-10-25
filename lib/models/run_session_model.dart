import 'package:cloud_firestore/cloud_firestore.dart';

/// Run_Session 데이터 모델 (AGENTS.md 4항 참조)
/// 개별 러닝 세션의 기록
class RunSessionModel {
  final String sessionId;
  final String userId; // 사용자 ID (User 컬렉션 참조)
  final DateTime startTime; // 러닝 시작 시간
  final int duration; // 총 러닝 시간 (초 단위로 변경 - 더 정밀함)
  final double distance; // 총 이동 거리 (km) (F-03)
  final int coinEarned; // 해당 세션에서 획득한 코인
  final DateTime? endTime; // 러닝 종료 시간
  final SessionStatus status; // 세션 상태

  RunSessionModel({
    required this.sessionId,
    required this.userId,
    required this.startTime,
    this.duration = 0,
    this.distance = 0.0,
    this.coinEarned = 0,
    this.endTime,
    this.status = SessionStatus.inProgress,
  });

  /// Firestore 문서를 RunSessionModel로 변환
  factory RunSessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RunSessionModel(
      sessionId: doc.id,
      userId: data['user_id'] as String,
      startTime: (data['start_time'] as Timestamp).toDate(),
      duration: data['duration'] as int? ?? 0,
      distance: (data['distance'] as num?)?.toDouble() ?? 0.0,
      coinEarned: data['coin_earned'] as int? ?? 0,
      endTime: data['end_time'] != null
          ? (data['end_time'] as Timestamp).toDate()
          : null,
      status: SessionStatus.fromString(data['status'] as String? ?? 'in_progress'),
    );
  }

  /// RunSessionModel을 Firestore 문서로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'start_time': Timestamp.fromDate(startTime),
      'duration': duration,
      'distance': distance,
      'coin_earned': coinEarned,
      'end_time': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'status': status.value,
    };
  }

  /// 세션 완료 처리
  RunSessionModel complete({
    required int finalDuration,
    required double finalDistance,
    required int earnedCoins,
  }) {
    return copyWith(
      duration: finalDuration,
      distance: finalDistance,
      coinEarned: earnedCoins,
      endTime: DateTime.now(),
      status: SessionStatus.completed,
    );
  }

  /// 세션 일시정지
  RunSessionModel pause() {
    return copyWith(status: SessionStatus.paused);
  }

  /// 세션 재개
  RunSessionModel resume() {
    return copyWith(status: SessionStatus.inProgress);
  }

  /// 세션 취소
  RunSessionModel cancel() {
    return copyWith(
      status: SessionStatus.cancelled,
      endTime: DateTime.now(),
    );
  }

  /// 러닝 시간을 분:초 형식으로 반환
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 거리를 포맷팅하여 반환 (소수점 2자리)
  String get formattedDistance {
    return '${distance.toStringAsFixed(2)} km';
  }

  /// copyWith 메서드
  RunSessionModel copyWith({
    String? sessionId,
    String? userId,
    DateTime? startTime,
    int? duration,
    double? distance,
    int? coinEarned,
    DateTime? endTime,
    SessionStatus? status,
  }) {
    return RunSessionModel(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      coinEarned: coinEarned ?? this.coinEarned,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'RunSessionModel(sessionId: $sessionId, duration: $formattedDuration, distance: $formattedDistance, status: ${status.value})';
  }
}

/// 세션 상태 enum
enum SessionStatus {
  inProgress('in_progress'),
  paused('paused'),
  completed('completed'),
  cancelled('cancelled');

  const SessionStatus(this.value);
  final String value;

  static SessionStatus fromString(String value) {
    return SessionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => SessionStatus.inProgress,
    );
  }
}

