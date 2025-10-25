// Run-Fit 앱 위젯 테스트

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runfit_flutter_vibeton/main.dart';

void main() {
  testWidgets('Run-Fit app smoke test', (WidgetTester tester) async {
    // Run-Fit 앱을 빌드하고 프레임을 트리거합니다.
    await tester.pumpWidget(const RunFitApp());

    // 스플래시 화면에 'Run-Fit' 텍스트가 있는지 확인합니다.
    expect(find.text('Run-Fit'), findsOneWidget);

    // 러닝 아이콘이 있는지 확인합니다.
    expect(find.byIcon(Icons.directions_run), findsOneWidget);

    // 로딩 인디케이터가 있는지 확인합니다.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
