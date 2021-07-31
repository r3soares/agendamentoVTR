import 'package:agendamento_vtr/app/modules/agendamento/agenda_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/agendamento_page.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pesquisa_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AgendamentoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => PesquisaController()),
    Bind.singleton((i) => AgendaStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => AgendamentoPage()),
  ];
}
