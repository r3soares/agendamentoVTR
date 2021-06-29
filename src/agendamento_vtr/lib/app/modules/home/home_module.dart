import 'package:agendamento_vtr/app/modules/agendamento/agendamento_module.dart';
import 'package:agendamento_vtr/app/modules/tanque/tanque_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../home/home_store.dart';

import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => HomePage()),
    ModuleRoute('/tanque', module: TanqueModule()),
    ModuleRoute('/agendamento', module: AgendamentoModule()),
  ];
}
