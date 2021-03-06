import 'package:agendamento_vtr/app/message_controller.dart';
import 'package:agendamento_vtr/app/modules/agendamento/agendamento_module.dart';
import 'package:agendamento_vtr/app/repositories/repository_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RepositoryStore()),
    Bind.lazySingleton((i) => MessageController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: AgendamentoModule()),
  ];
}
