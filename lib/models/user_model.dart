import 'package:cloud_firestore/cloud_firestore.dart';

/// User 데이터 모델 (AGENTS.md 4항 참조)
/// Firebase Authentication과 연동되는 사용자 정보
class UserModel {
  final String userId;
  final String email;
  final int totalCoin; // 누적된 건강 코인 잔액 (F-04)
  final int currentStreak; // 현재 연속 러닝 횟수 (F-05)
  final DateTime? lastRunDate; // 마지막 러닝 날짜 (스트릭 계산용)
  final DateTime? notifyTime; // 푸시 알림 희망 시간 (F-06)
  final bool notifyStatus; // 푸시 알림 수신 여부 (F-06)
  final DateTime createdAt; // 계정 생성 시간
  final DateTime updatedAt; // 마지막 업데이트 시간

  UserModel({
    required this.userId,
    required this.email,
    this.totalCoin = 0,
    this.currentStreak = 0,
    this.lastRunDate,
    this.notifyTime,
    this.notifyStatus = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Firestore 문서를 UserModel로 변환
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      email: data['email'] as String,
      totalCoin: data['total_coin'] as int? ?? 0,
      currentStreak: data['current_streak'] as int? ?? 0,
      lastRunDate: data['last_run_date'] != null
          ? (data['last_run_date'] as Timestamp).toDate()
          : null,
      notifyTime: data['notify_time'] != null
          ? (data['notify_time'] as Timestamp).toDate()
          : null,
      notifyStatus: data['notify_status'] as bool? ?? true,
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// UserModel을 Firestore 문서로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'total_coin': totalCoin,
      'current_streak': currentStreak,
      'last_run_date':
          lastRunDate != null ? Timestamp.fromDate(lastRunDate!) : null,
      'notify_time': notifyTime != null ? Timestamp.fromDate(notifyTime!) : null,
      'notify_status': notifyStatus,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  /// 코인 추가 (러닝 완료 시)
  UserModel addCoin(int amount) {
    return copyWith(
      totalCoin: totalCoin + amount,
      updatedAt: DateTime.now(),
    );
  }

  /// 스트릭 증가
  UserModel incrementStreak() {
    return copyWith(
      currentStreak: currentStreak + 1,
      updatedAt: DateTime.now(),
    );
  }

  /// 스트릭 리셋
  UserModel resetStreak() {
    return copyWith(
      currentStreak: 0,
      updatedAt: DateTime.now(),
    );
  }

  /// 알림 설정 업데이트
  UserModel updateNotificationSettings({
    DateTime? notifyTime,
    bool? notifyStatus,
  }) {
    return copyWith(
      notifyTime: notifyTime ?? this.notifyTime,
      notifyStatus: notifyStatus ?? this.notifyStatus,
      updatedAt: DateTime.now(),
    );
  }

  /// copyWith 메서드
  UserModel copyWith({
    String? userId,
    String? email,
    int? totalCoin,
    int? currentStreak,
    DateTime? lastRunDate,
    DateTime? notifyTime,
    bool? notifyStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      totalCoin: totalCoin ?? this.totalCoin,
      currentStreak: currentStreak ?? this.currentStreak,
      lastRunDate: lastRunDate ?? this.lastRunDate,
      notifyTime: notifyTime ?? this.notifyTime,
      notifyStatus: notifyStatus ?? this.notifyStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, email: $email, totalCoin: $totalCoin, currentStreak: $currentStreak)';
  }
}

