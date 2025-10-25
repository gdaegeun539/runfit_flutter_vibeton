import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

/// 단순화된 인증 Provider (익명 로그인만 지원)
/// 별도의 로그인 없이 익명 사용자로 Firebase 데이터 사용
class SimpleAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = true;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _firebaseUser != null;
  String? get userId => _firebaseUser?.uid;

  SimpleAuthProvider() {
    _initAuth();
  }

  /// 초기 인증 설정 (자동 익명 로그인)
  Future<void> _initAuth() async {
    try {
      // 기존 사용자 확인
      _firebaseUser = _auth.currentUser;

      if (_firebaseUser == null) {
        // 익명 로그인
        final credential = await _auth.signInAnonymously();
        _firebaseUser = credential.user;
      }

      if (_firebaseUser != null) {
        await _loadOrCreateUserModel(_firebaseUser!.uid);
      }
    } catch (e) {
      debugPrint('익명 로그인 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Firestore에서 사용자 모델 로드 또는 생성
  Future<void> _loadOrCreateUserModel(String userId) async {
    try {
      // 기존 사용자 모델 확인
      _userModel = await _firestoreService.getUser(userId);

      // 없으면 새로 생성
      if (_userModel == null) {
        _userModel = UserModel(
          userId: userId,
          email: 'anonymous@runfit.app',
          totalCoin: 0,
          currentStreak: 0,
          notifyStatus: true,
        );
        await _firestoreService.createUser(_userModel!);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('사용자 모델 로드/생성 실패: $e');
    }
  }

  /// 사용자 정보 새로고침
  Future<void> refreshUserModel() async {
    if (_firebaseUser != null) {
      await _loadOrCreateUserModel(_firebaseUser!.uid);
    }
  }

  /// 앱 시작 (더미 로그인)
  Future<void> startApp() async {
    if (_firebaseUser == null) {
      await _initAuth();
    }
  }
}

