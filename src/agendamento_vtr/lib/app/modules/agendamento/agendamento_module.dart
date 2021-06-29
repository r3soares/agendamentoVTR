import 'package:agendamento_vtr/app/modules/agendamento/pages/agendamento_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AgendamentoModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => AgendamentoPage()),
  ];
}
