import 'package:flutter_test/flutter_test.dart';
import 'package:on_stage_app/app/app.dart';

void main() {
  group('App', () {
    testWidgets('renders App', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(App), findsOneWidget);
    });
  });
}
