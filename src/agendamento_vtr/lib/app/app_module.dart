import 'package:agendamento_vtr/app/modules/agendamento/agenda_repository.dart';
import 'package:agendamento_vtr/app/repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/home/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => Repository()),
    Bind.lazySingleton((i) => AgendaRepository()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];
}
