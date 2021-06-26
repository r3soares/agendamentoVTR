import 'package:agendamento_vtr/app/modules/tanque/widgets/formulario_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular_test/flutter_modular_test.dart';

main() {
  group('FormularioWidget', () {
    testWidgets('has a title and message', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(FormularioWidget()));
      final titleFinder = find.text('T');
      expect(titleFinder, findsOneWidget);
    });
  });
}
