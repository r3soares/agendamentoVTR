import 'package:agendamento_vtr/app/modules/tanque/widgets/proprietario_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular_test/flutter_modular_test.dart';

main() {
  group('FormularioWidget', () {
    testWidgets('has a title and message', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(ProprietarioWidget()));
      final titleFinder = find.text('T');
      expect(titleFinder, findsOneWidget);
    });
  });
}
