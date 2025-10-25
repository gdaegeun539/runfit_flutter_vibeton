import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

/// Firebase Authentication 서비스
/// 이메일/비밀번호 및 Google 소셜 로그인 지원
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirestoreService _firestoreService = FirestoreService();

  /// 현재 로그인된 사용자
  User? get currentUser => _auth.currentUser;

  /// 로그인 상태 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ==================== 이메일/비밀번호 인증 ====================

  /// 이메일/비밀번호로 회원가입
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore에 사용자 문서 생성
      if (credential.user != null) {
        final userModel = UserModel(userId: credential.user!.uid, email: email);
        await _firestoreService.createUser(userModel);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// 이메일/비밀번호로 로그인
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ==================== Google 소셜 로그인 ====================

  /// Google 계정으로 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google 로그인 프로세스 시작
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Google 인증 정보 획득 (google_sign_in 7.2.0+ 버전)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Firebase 자격 증명 생성 (idToken만 사용)
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인
      final userCredential = await _auth.signInWithCredential(credential);

      // 신규 사용자인 경우 Firestore에 문서 생성
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final userModel = UserModel(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
        );
        await _firestoreService.createUser(userModel);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Google 로그인 중 오류가 발생했습니다: $e');
    }
  }

  // ==================== 로그아웃 및 계정 관리 ====================

  /// 로그아웃
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  /// 비밀번호 재설정 이메일 전송
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// 계정 삭제
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        // Firestore 데이터 삭제는 별도로 처리 필요
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// 이메일 인증 메일 전송
  Future<void> sendEmailVerification() async {
    final user = currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // ==================== 에러 처리 ====================

  /// Firebase Auth 예외를 사용자 친화적인 메시지로 변환
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return '비밀번호가 너무 약합니다. 더 강력한 비밀번호를 사용해주세요.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'invalid-email':
        return '유효하지 않은 이메일 주소입니다.';
      case 'user-not-found':
        return '등록되지 않은 사용자입니다.';
      case 'wrong-password':
        return '잘못된 비밀번호입니다.';
      case 'user-disabled':
        return '비활성화된 계정입니다.';
      case 'too-many-requests':
        return '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.';
      case 'operation-not-allowed':
        return '이 로그인 방법은 현재 사용할 수 없습니다.';
      case 'network-request-failed':
        return '네트워크 연결을 확인해주세요.';
      default:
        return '인증 중 오류가 발생했습니다: ${e.message}';
    }
  }
}
