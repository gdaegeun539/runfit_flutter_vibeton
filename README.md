# 🏃 Run-Fit

초보 러너를 위한 간편한 러닝 앱

## 📱 프로젝트 소개

Run-Fit은 러닝을 처음 시작하는 초보자들을 위한 모바일 애플리케이션입니다.
간단한 인터페이스와 음성 코칭을 통해 누구나 쉽게 러닝을 시작할 수 있도록 돕습니다.

### 주요 기능 (MVP)

- ✅ **간편 러닝 시작**: 복잡한 설정 없이 바로 시작
- 🎯 **인터벌 트레이닝**: 초보자를 위한 걷기/뛰기 조합
- 🎤 **음성 코칭**: 실시간 음성 안내
- 🪙 **건강 코인 시스템**: 러닝 보상 및 동기 부여
- 🔥 **연속 스트릭**: 꾸준한 운동 습관 형성
- 💡 **시니어 조언**: 경험자들의 실용적인 팁

## 🛠 기술 스택

- **Framework**: Flutter (Dart 3.9.2+)
- **Backend**: Firebase (Authentication, Firestore, Cloud Messaging)
- **State Management**: Provider (예정)
- **Architecture**: Clean Architecture (예정)

## 📋 개발 환경 설정

### 필수 요구사항

- Flutter SDK 3.9.2 이상
- Dart 3.9.2 이상
- iOS 개발: Xcode 14.0 이상
- Android 개발: Android Studio

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
├── core/                  # 핵심 기능 (예정)
├── features/              # 기능별 모듈 (예정)
│   ├── auth/             # 인증
│   ├── running/          # 러닝 기능
│   └── dashboard/        # 대시보드
└── shared/               # 공유 위젯/유틸 (예정)
```

## 🚀 개발 로드맵

현재 진행 상황은 `PRD.md` 파일을 참조하세요.

### Phase 1: 프로젝트 기반 공사 🚧

- [x] Flutter 프로젝트 초기화
- [x] Firebase 패키지 설정 (Console 설정 대기 중)
- [x] 데이터 모델 생성
- [ ] 사용자 인증 구현

### Phase 2: 핵심 UI 및 기능 구현

- [ ] 메인 대시보드
- [ ] 러닝 화면
- [ ] 인터벌 타이머
- [ ] GPS 거리 계산

### Phase 3: 보상 및 동기 부여

- [ ] 러닝 요약 화면
- [ ] 건강 코인 시스템
- [ ] 푸시 알림

## 📝 코드 컨벤션

- Dart 공식 스타일 가이드 준수
- `flutter_lints` 패키지 기반 린트 규칙 적용
- Single quotes 사용
- Const 생성자 선호

## 📄 라이선스

이 프로젝트는 개인 프로젝트입니다.

## 👥 기여

현재는 개인 개발 프로젝트입니다.
