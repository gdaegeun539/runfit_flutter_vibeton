# 🔥 Firebase 설정 가이드

Run-Fit 앱의 Firebase 연동을 완료하기 위한 단계별 가이드입니다.

## ✅ 완료된 작업

- [x] pubspec.yaml에 Firebase 패키지 추가 (최신 버전으로 업데이트 완료)
  - firebase_core: ^4.2.0
  - firebase_auth: ^6.1.1
  - cloud_firestore: ^6.0.3 (firebase_firestore에서 변경)
  - firebase_messaging: ^16.0.3
  - google_sign_in: ^7.2.0
  - 기타 패키지 최신화
- [x] Android build.gradle.kts 설정
- [x] iOS Info.plist 권한 설정
- [x] Android AndroidManifest.xml 권한 설정
- [x] Firebase 초기화 코드 준비 (주석 처리)
- [x] Firestore 데이터 모델 클래스 생성
  - `lib/models/user_model.dart`
  - `lib/models/run_session_model.dart`
- [x] Firebase 서비스 클래스 생성
  - `lib/services/auth_service.dart`
  - `lib/services/firestore_service.dart`
- [x] 패키지 설치 완료 (`flutter pub get`)

## 📋 남은 작업

### 1. Firebase Console 설정

#### 1-1. Firebase 프로젝트 생성

1. https://console.firebase.google.com/ 접속
2. "프로젝트 추가" 클릭
3. 프로젝트 이름: **Run-Fit** (또는 원하는 이름)
4. Google Analytics 설정 (선택사항)

#### 1-2. iOS 앱 등록

1. Firebase Console > 프로젝트 설정 > 앱 추가 > iOS
2. **Bundle ID 확인 방법:**
   ```bash
   # Xcode에서 확인하거나
   cat ios/Runner.xcodeproj/project.pbxproj | grep PRODUCT_BUNDLE_IDENTIFIER
   ```
   기본값: `com.example.runfitFlutterVibeton`
3. `GoogleService-Info.plist` 다운로드
4. 파일을 `ios/Runner/` 폴더에 복사

#### 1-3. Android 앱 등록

1. Firebase Console > 프로젝트 설정 > 앱 추가 > Android
2. **Package name:** `com.example.runfit_flutter_vibeton`
   (이미 `android/app/build.gradle.kts`에 설정됨)
3. `google-services.json` 다운로드
4. 파일을 `android/app/` 폴더에 복사

### 2. FlutterFire CLI 설정

```bash
# 프로젝트 루트에서 실행
cd /Users/gosiphone/Repo/runfit_flutter_vibeton

# FlutterFire 설정 (Firebase 프로젝트와 연동)
flutterfire configure

# 프롬프트에서:
# - Firebase 프로젝트 선택
# - 플랫폼 선택: iOS, Android
```

이 명령어는 자동으로:

- `lib/firebase_options.dart` 파일 생성
- `android/app/build.gradle.kts`에 google-services 플러그인 활성화

### 3. 코드 주석 해제

`lib/main.dart` 파일에서 Firebase 초기화 코드 주석 해제:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  // 주석 해제
import 'firebase_options.dart';  // 주석 해제

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // 주석 해제
  await Firebase.initializeApp(  // 주석 해제
    options: DefaultFirebaseOptions.currentPlatform,  // 주석 해제
  );  // 주석 해제

  runApp(const RunFitApp());
}
```

### 4. Android google-services 플러그인 활성화

`android/app/build.gradle.kts` 파일에서:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // 주석 해제
}
```

### 5. 패키지 설치 및 빌드

```bash
# 패키지 설치
flutter pub get

# 빌드 테스트
flutter build apk --debug  # Android
flutter build ios --debug  # iOS
```

### 6. Firebase 서비스 활성화

#### 6-1. Authentication 설정

1. Firebase Console > **Authentication** > 시작하기
2. **Sign-in method** 탭 선택
3. **이메일/비밀번호** 활성화
4. **Google** 로그인 활성화 (선택사항)
   - 프로젝트 지원 이메일 설정

#### 6-2. Firestore Database 생성

1. Firebase Console > **Firestore Database** > 데이터베이스 만들기
2. **테스트 모드로 시작** 선택 (나중에 보안 규칙 설정)
3. 위치 선택: **asia-northeast3 (서울)**

#### 6-3. Cloud Messaging 설정

1. Firebase Console > **Cloud Messaging**
2. **iOS 설정:**
   - APNs 인증 키 업로드 (Apple Developer에서 생성 필요)
3. **Android:** 자동 설정됨 (google-services.json에 포함)

### 7. Google Sign-In iOS 추가 설정 (선택사항)

Google 로그인을 사용하는 경우, `ios/Runner/Info.plist`에서 주석 해제:

1. `GoogleService-Info.plist`에서 `REVERSED_CLIENT_ID` 값 확인
2. `Info.plist`에서 해당 부분 주석 해제 및 값 입력:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>YOUR-REVERSED-CLIENT-ID</string>
    </array>
  </dict>
</array>
```

## 🧪 테스트

### Firebase 연결 테스트

```bash
flutter run
```

앱이 정상적으로 실행되고 Firebase 초기화 에러가 없으면 성공!

### 간단한 테스트 코드

`lib/main.dart`의 `SplashScreen`에서 Firebase 연결 확인:

```dart
@override
void initState() {
  super.initState();
  _checkFirebaseConnection();
}

Future<void> _checkFirebaseConnection() async {
  try {
    // Firebase 연결 확인
    print('Firebase initialized: ${Firebase.apps.isNotEmpty}');

    // Firestore 연결 테스트
    await FirebaseFirestore.instance
        .collection('test')
        .doc('connection')
        .set({'timestamp': FieldValue.serverTimestamp()});

    print('✅ Firebase 연결 성공!');
  } catch (e) {
    print('❌ Firebase 연결 실패: $e');
  }
}
```

## 📚 생성된 파일 구조

```
lib/
├── models/
│   ├── user_model.dart           # User 데이터 모델
│   └── run_session_model.dart    # RunSession 데이터 모델
├── services/
│   ├── auth_service.dart         # 인증 서비스
│   └── firestore_service.dart    # Firestore CRUD 서비스
├── firebase_options.dart         # (flutterfire configure로 생성됨)
└── main.dart                     # Firebase 초기화 포함
```

## 🔐 Firestore 보안 규칙 (추후 설정)

테스트 완료 후, Firebase Console > Firestore > 규칙에서 다음 규칙 적용:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User 컬렉션: 본인만 읽기/쓰기 가능
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Run_Session 컬렉션: 본인 세션만 읽기/쓰기 가능
    match /run_sessions/{sessionId} {
      allow read, write: if request.auth != null &&
        resource.data.user_id == request.auth.uid;
    }
  }
}
```

## ❓ 문제 해결

### 빌드 에러 발생 시

```bash
# 캐시 정리
flutter clean
flutter pub get

# iOS Pod 재설치
cd ios
pod deintegrate
pod install
cd ..

# Android Gradle 캐시 정리
cd android
./gradlew clean
cd ..
```

### Firebase 초기화 실패 시

1. `google-services.json` (Android)와 `GoogleService-Info.plist` (iOS) 파일 위치 확인
2. `flutterfire configure` 재실행
3. Bundle ID / Package name 일치 여부 확인

## 📞 다음 단계

Firebase 설정이 완료되면 **PRD.md의 Phase 1, Task 4**: "사용자 인증 (Auth) 기능 구현"을 진행할 수 있습니다!
