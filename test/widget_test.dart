import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/app.dart';

void main() {
  testWidgets('App launches with splash page', (WidgetTester tester) async {
    await tester.pumpWidget(const JelloMarkOwnerApp());

    expect(find.text('젤로마크'), findsOneWidget);
    expect(find.text('사장님'), findsOneWidget);
  });
}
