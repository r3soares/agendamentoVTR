import 'package:agendamento_vtr/app/message_controller.dart';
import 'package:agendamento_vtr/app/modules/agendamento/agenda_repository.dart';
import 'package:agendamento_vtr/app/repositories/repository_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/home/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RepositoryStore()),
    Bind.lazySingleton((i) => AgendaRepository()),
    Bind.lazySingleton((i) => MessageController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];
}
