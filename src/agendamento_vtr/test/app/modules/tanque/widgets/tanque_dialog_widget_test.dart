import 'package:agendamento_vtr/app/modules/tanque/pages/tanque_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular_test/flutter_modular_test.dart';

main() {
  group('TanqueDialogWidget', () {
    testWidgets('has a title and message', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(TanqueDialog()));
      final titleFinder = find.text('T');
      expect(titleFinder, findsOneWidget);
    });
  });
}
