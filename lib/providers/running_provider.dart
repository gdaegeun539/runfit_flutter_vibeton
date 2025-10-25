import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// 러닝 세션 상태
enum RunningState {
  idle, // 대기 중
  running, // 실행 중
  paused, // 일시정지
  finished, // 종료됨
}

/// 러닝 세션 상태 관리 Provider
/// 타이머, GPS 거리 추적, 속도 계산 등을 담당
class RunningProvider extends ChangeNotifier {
  // 상태
  RunningState _state = RunningState.idle;
  RunningState get state => _state;

  // 시간 (초 단위)
  int _elapsedSeconds = 0;
  int get elapsedSeconds => _elapsedSeconds;

  // 거리 (미터 단위)
  double _distanceMeters = 0.0;
  double get distanceMeters => _distanceMeters;
  double get distanceKm => _distanceMeters / 1000;

  // 속도 (km/h)
  double _currentSpeed = 0.0;
  double get currentSpeed => _currentSpeed;

  // 평균 속도 (km/h)
  double get averageSpeed {
    if (_elapsedSeconds == 0) return 0.0;
    return (distanceKm / (_elapsedSeconds / 3600));
  }

  // 타이머
  Timer? _timer;

  // GPS 위치 추적
  Position? _lastPosition;
  StreamSubscription<Position>? _positionStream;

  // 시작 시간
  DateTime? _startTime;
  DateTime? get startTime => _startTime;

  /// 러닝 세션 시작
  Future<void> startRunning() async {
    if (_state == RunningState.running) return;

    // 위치 권한 확인
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      throw Exception('위치 권한이 필요합니다');
    }

    // 상태 초기화 (새로 시작하는 경우)
    if (_state == RunningState.idle) {
      _elapsedSeconds = 0;
      _distanceMeters = 0.0;
      _currentSpeed = 0.0;
      _lastPosition = null;
      _startTime = DateTime.now();
    }

    _state = RunningState.running;

    // 타이머 시작
    _startTimer();

    // GPS 추적 시작
    _startLocationTracking();

    notifyListeners();
  }

  /// 러닝 일시정지
  void pauseRunning() {
    if (_state != RunningState.running) return;

    _state = RunningState.paused;
    _stopTimer();
    _stopLocationTracking();

    notifyListeners();
  }

  /// 러닝 재개
  Future<void> resumeRunning() async {
    if (_state != RunningState.paused) return;
    await startRunning();
  }

  /// 러닝 종료
  void finishRunning() {
    _state = RunningState.finished;
    _stopTimer();
    _stopLocationTracking();

    notifyListeners();
  }

  /// 러닝 세션 리셋
  void resetSession() {
    _state = RunningState.idle;
    _elapsedSeconds = 0;
    _distanceMeters = 0.0;
    _currentSpeed = 0.0;
    _lastPosition = null;
    _startTime = null;

    _stopTimer();
    _stopLocationTracking();

    notifyListeners();
  }

  /// 타이머 시작
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }

  /// 타이머 정지
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// 위치 추적 시작
  void _startLocationTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // 10미터마다 업데이트
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _updatePosition(position);
          },
        );
  }

  /// 위치 추적 정지
  void _stopLocationTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  /// 위치 업데이트 처리
  void _updatePosition(Position newPosition) {
    if (_lastPosition != null) {
      // 이전 위치와의 거리 계산
      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      // 거리 누적 (비현실적인 값 필터링)
      if (distance < 100) {
        // 100m 이상 점프는 무시
        _distanceMeters += distance;
      }

      // 현재 속도 계산 (m/s -> km/h)
      _currentSpeed = newPosition.speed * 3.6;
      if (_currentSpeed < 0) _currentSpeed = 0;
    }

    _lastPosition = newPosition;
    notifyListeners();
  }

  /// 위치 권한 확인 및 요청
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// 포맷된 시간 문자열 (HH:MM:SS)
  String get formattedTime {
    final hours = _elapsedSeconds ~/ 3600;
    final minutes = (_elapsedSeconds % 3600) ~/ 60;
    final seconds = _elapsedSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// 포맷된 거리 문자열
  String get formattedDistance {
    if (distanceKm < 1) {
      return '${_distanceMeters.toStringAsFixed(0)}m';
    }
    return '${distanceKm.toStringAsFixed(2)}km';
  }

  /// 포맷된 속도 문자열
  String get formattedSpeed {
    return '${_currentSpeed.toStringAsFixed(1)} km/h';
  }

  @override
  void dispose() {
    _stopTimer();
    _stopLocationTracking();
    super.dispose();
  }
}
