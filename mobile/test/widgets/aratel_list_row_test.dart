import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/widgets/aratel_list_row.dart';

void main() {
  testWidgets('AratelListRow renders title, subtitle, leading and trailing widgets', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AratelListRow(
            title: '테스트 제목',
            subtitle: '테스트 부제목',
            leading: const Icon(Icons.star),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('테스트 제목'), findsOneWidget);
    expect(find.text('테스트 부제목'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

    await tester.tap(find.byType(AratelListRow));
    expect(tapped, isTrue);
  });
}
