import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/run_session_model.dart';

/// Firestore 데이터베이스 서비스
/// User 및 Run_Session 컬렉션에 대한 CRUD 작업 제공
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 컬렉션 참조
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _runSessionsCollection =>
      _firestore.collection('run_sessions');

  // ==================== User 관련 메서드 ====================

  /// 새 사용자 생성
  Future<void> createUser(UserModel user) async {
    await _usersCollection.doc(user.userId).set(user.toFirestore());
  }

  /// 사용자 정보 조회
  Future<UserModel?> getUser(String userId) async {
    final doc = await _usersCollection.doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  /// 사용자 정보 업데이트
  Future<void> updateUser(UserModel user) async {
    await _usersCollection.doc(user.userId).update(user.toFirestore());
  }

  /// 사용자 실시간 스트림
  Stream<UserModel?> userStream(String userId) {
    return _usersCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// 코인 추가 (트랜잭션)
  Future<void> addCoins(String userId, int amount) async {
    await _firestore.runTransaction((transaction) async {
      final userRef = _usersCollection.doc(userId);
      final userDoc = await transaction.get(userRef);

      if (userDoc.exists) {
        final currentCoins = userDoc.get('total_coin') as int? ?? 0;
        transaction.update(userRef, {
          'total_coin': currentCoins + amount,
          'updated_at': Timestamp.now(),
        });
      }
    });
  }

  /// 스트릭 업데이트 (트랜잭션)
  Future<void> updateStreak(String userId, int newStreak) async {
    await _usersCollection.doc(userId).update({
      'current_streak': newStreak,
      'updated_at': Timestamp.now(),
    });
  }

  /// 알림 설정 업데이트
  Future<void> updateNotificationSettings({
    required String userId,
    DateTime? notifyTime,
    bool? notifyStatus,
  }) async {
    final Map<String, dynamic> updates = {'updated_at': Timestamp.now()};

    if (notifyTime != null) {
      updates['notify_time'] = Timestamp.fromDate(notifyTime);
    }
    if (notifyStatus != null) {
      updates['notify_status'] = notifyStatus;
    }

    await _usersCollection.doc(userId).update(updates);
  }

  /// 러닝 세션 저장 및 보상 지급 (Task 12)
  /// Run_Session 저장 + User의 코인/스트릭 업데이트를 트랜잭션으로 처리
  Future<String> saveRunningSessionWithReward({
    required String userId,
    required DateTime startTime,
    required int durationSeconds,
    required double distanceKm,
    int coinReward = 100, // 기본 보상: 100 코인
  }) async {
    String sessionId = '';

    await _firestore.runTransaction((transaction) async {
      // 1. 사용자 정보 조회
      final userRef = _usersCollection.doc(userId);
      final userDoc = await transaction.get(userRef);

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final currentCoins = userData['total_coin'] as int? ?? 0;
      final currentStreak = userData['current_streak'] as int? ?? 0;
      final lastRunDate = userData['last_run_date'] != null
          ? (userData['last_run_date'] as Timestamp).toDate()
          : null;

      // 2. 스트릭 계산
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      int newStreak = currentStreak;

      if (lastRunDate == null) {
        // 첫 러닝
        newStreak = 1;
      } else {
        final lastDate =
            DateTime(lastRunDate.year, lastRunDate.month, lastRunDate.day);
        final daysDifference = todayDate.difference(lastDate).inDays;

        if (daysDifference == 0) {
          // 오늘 이미 러닝함 (스트릭 유지)
          newStreak = currentStreak;
        } else if (daysDifference == 1) {
          // 어제 러닝함 (스트릭 증가)
          newStreak = currentStreak + 1;
        } else {
          // 하루 이상 건너뜀 (스트릭 리셋)
          newStreak = 1;
        }
      }

      // 3. Run_Session 생성
      final sessionRef = _runSessionsCollection.doc();
      sessionId = sessionRef.id;

      final session = RunSessionModel(
        sessionId: sessionId,
        userId: userId,
        startTime: startTime,
        duration: durationSeconds,
        distance: distanceKm,
        coinEarned: coinReward,
      );

      transaction.set(sessionRef, session.toFirestore());

      // 4. User 업데이트 (코인, 스트릭, 마지막 러닝 날짜)
      transaction.update(userRef, {
        'total_coin': currentCoins + coinReward,
        'current_streak': newStreak,
        'last_run_date': Timestamp.fromDate(today),
        'updated_at': Timestamp.now(),
      });
    });

    return sessionId;
  }

  // ==================== Run_Session 관련 메서드 ====================

  /// 새 러닝 세션 생성
  Future<String> createRunSession(RunSessionModel session) async {
    final docRef = await _runSessionsCollection.add(session.toFirestore());
    return docRef.id;
  }

  /// 러닝 세션 조회
  Future<RunSessionModel?> getRunSession(String sessionId) async {
    final doc = await _runSessionsCollection.doc(sessionId).get();
    if (doc.exists) {
      return RunSessionModel.fromFirestore(doc);
    }
    return null;
  }

  /// 러닝 세션 업데이트
  Future<void> updateRunSession(RunSessionModel session) async {
    await _runSessionsCollection
        .doc(session.sessionId)
        .update(session.toFirestore());
  }

  /// 러닝 세션 삭제
  Future<void> deleteRunSession(String sessionId) async {
    await _runSessionsCollection.doc(sessionId).delete();
  }

  /// 사용자의 모든 러닝 세션 조회 (최신순)
  Future<List<RunSessionModel>> getUserRunSessions(
    String userId, {
    int limit = 20,
  }) async {
    final querySnapshot = await _runSessionsCollection
        .where('user_id', isEqualTo: userId)
        .orderBy('start_time', descending: true)
        .limit(limit)
        .get();

    return querySnapshot.docs
        .map((doc) => RunSessionModel.fromFirestore(doc))
        .toList();
  }

  /// 사용자의 러닝 세션 실시간 스트림
  Stream<List<RunSessionModel>> userRunSessionsStream(
    String userId, {
    int limit = 20,
  }) {
    return _runSessionsCollection
        .where('user_id', isEqualTo: userId)
        .orderBy('start_time', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RunSessionModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// 특정 날짜의 러닝 세션 조회
  Future<List<RunSessionModel>> getRunSessionsByDate(
    String userId,
    DateTime date,
  ) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final querySnapshot = await _runSessionsCollection
        .where('user_id', isEqualTo: userId)
        .where(
          'start_time',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('start_time', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('start_time', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => RunSessionModel.fromFirestore(doc))
        .toList();
  }

  /// 사용자의 총 러닝 통계 계산
  Future<Map<String, dynamic>> getUserRunStats(String userId) async {
    final sessions = await getUserRunSessions(userId, limit: 1000);
    final completedSessions = sessions
        .where((s) => s.status == SessionStatus.completed)
        .toList();

    final totalDistance = completedSessions.fold<double>(
      0,
      (total, s) => total + s.distance,
    );
    final totalDuration = completedSessions.fold<int>(
      0,
      (total, s) => total + s.duration,
    );
    final totalCoins = completedSessions.fold<int>(
      0,
      (total, s) => total + s.coinEarned,
    );

    return {
      'total_sessions': completedSessions.length,
      'total_distance': totalDistance,
      'total_duration': totalDuration,
      'total_coins': totalCoins,
      'average_distance': completedSessions.isEmpty
          ? 0
          : totalDistance / completedSessions.length,
      'average_duration': completedSessions.isEmpty
          ? 0
          : totalDuration / completedSessions.length,
    };
  }
}
