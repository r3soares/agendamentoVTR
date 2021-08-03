import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/tanque/pages/tanque_page.dart';
import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TanqueModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => Empresa()),
    Bind.singleton((i) => PesquisaController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => TanquePage()),
  ];
}
