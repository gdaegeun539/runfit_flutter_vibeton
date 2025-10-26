# 🏃 Run-Fit

초보 러너를 위한 간편한 러닝 앱

## 📱 프로젝트 소개

Run-Fit은 러닝을 처음 시작하는 초보자들을 위한 모바일 애플리케이션입니다.
간단한 인터페이스와 음성 코칭을 통해 누구나 쉽게 러닝을 시작할 수 있도록 돕습니다.

### 주요 기능 (MVP)

- ✅ **간편 러닝 시작**: 복잡한 설정 없이 바로 시작

  ~~- 🎯 **인터벌 트레이닝**: 초보자를 위한 걷기/뛰기 조합~~
  ~~- 🎤 **음성 코칭**: 실시간 음성 안내~~

- 🪙 **건강 코인 시스템**: 러닝 보상 및 동기 부여
- 🔥 **연속 스트릭**: 꾸준한 운동 습관 형성
- 💡 **시니어 조언**: 경험자들의 실용적인 팁

## 🛠 기술 스택

- **Framework**: Flutter (Dart 3.9.2+)
- **Backend**: Firebase (Authentication, Firestore)
- **State Management**: Provider
- **Architecture**: MVVM, Feature-sliced

## 📋 개발 환경 설정

### 필수 요구사항

- Flutter SDK 3.35.6 이상
- Dart 3.9.2 이상

~~- iOS 개발: Xcode 14.0 이상~~
~~- Android 개발: Android Studio~~

### 설치 및 실행

```bash
# 저장소 클론
git clone [repository-url]
cd runfit_flutter_vibeton

# 의존성 설치
flutter pub get

# 앱 실행
flutter run
```

## 📂 프로젝트 구조

```
lib/
├── main.dart              # 앱 진입점
├── models/                # 데이터 모델
│   ├── user_model.dart
│   └── run_session_model.dart
├── services/              # 비즈니스 로직
│   ├── auth_service.dart
│   └── firestore_service.dart
├── providers/             # 상태 관리
│   ├── simple_auth_provider.dart
│   └── running_provider.dart
├── screens/               # 화면
│   ├── auth/
│   │   └── welcome_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   └── running/
│       ├── running_screen.dart
│       └── running_summary_screen.dart
└── widgets/               # 재사용 위젯
    ├── dashboard/
    │   ├── stat_card.dart
    │   ├── start_running_button.dart
    │   └── advice_card.dart
    └── running/
        ├── running_stat_display.dart
        └── running_control_buttons.dart
```

## 🚀 개발 로드맵

해커톤 당시 기획 및 기획에 대한 진행 내용은 `AGENTS.md`, `PRD.md` 파일을 참조하세요.

### Phase 1: 프로젝트 기반 공사 ✅

- [x] Flutter 프로젝트 초기화
- [x] Firebase 패키지 설정
- [x] 데이터 모델 생성 (User, RunSession)
- [x] 익명 인증 구현 (로그인 없이 바로 사용)

### Phase 2: 핵심 UI 및 기능 구현 ✅

- [x] **Task 5**: 메인 대시보드 UI 레이아웃 (F-01, F-04, F-05)
  - [x] 통계 카드 위젯 (건강 코인, 연속 스트릭)
  - [x] 러닝 시작 버튼
  - [x] 시니어 조언 카드
- [x] **Task 6**: 대시보드 데이터 연동 (Task 5에서 함께 구현됨)
- [x] **Task 7**: 시니어 조언 카드 UI (Task 5에서 함께 구현됨)
- [x] **Task 8**: 러닝 중 화면 UI (F-02)
  - [x] 러닝 세션 상태 관리 Provider
  - [x] GPS 위치 추적 및 거리 계산
  - [x] 실시간 타이머 및 통계 표시
  - [x] 일시정지/재개/종료 기능
- [x] **Task 9**: 인터벌 타이머 및 음성 코칭 (해커톤 MVP 스킵)
- [x] **Task 10**: 간이 거리 계산 로직 (Task 8에서 함께 구현됨)

### Phase 3: 보상 및 동기 부여 (일부 진행 예정 중 해커톤 종료)

- [x] **Task 11**: 러닝 요약 화면 UI (F-03)
  - [x] 축하 메시지 및 Confetti 애니메이션
  - [x] 총 시간, 거리, 획득 코인 표시
  - [x] 평균 속도 계산
  - [x] 홈으로 돌아가기 버튼
- [x] **Task 12**: 러닝 결과 저장 및 보상 로직 (F-04, F-05)
  - [x] Run_Session Firestore 저장
  - [x] 건강 코인 지급 (100 코인)
  - [x] 연속 스트릭 계산 및 업데이트
  - [x] 트랜잭션으로 데이터 일관성 보장
  - [x] **실시간 데이터 동기화**: Firestore 스트림으로 코인/스트릭 자동 갱신
- [ ] 푸시 알림 -> 해커톤 진행시간의 제약으로 해당 사항은 구현하지 않고 종료

## 📝 코드 컨벤션

- Dart 공식 스타일 가이드 준수
- `flutter_lints` 패키지 기반 린트 규칙 적용
- Single quotes 사용
- Const 생성자 선호

## 📄 라이선스

바이브코딩으로 생성된 결과물에는 라이선스가 불명확합니다.
이후 수동으로 작성되어 추가되는 결과물은 MIT 라이선스에 기반합니다.
LICENSE 파일을 참고하세요.

## 👥 기여

해커톤 프로젝트로, 모든 기여를 환영합니다.
