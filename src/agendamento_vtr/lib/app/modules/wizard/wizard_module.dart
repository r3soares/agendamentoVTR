import 'package:agendamento_vtr/app/modules/wizard/pages/main_page.dart';
import 'package:agendamento_vtr/app/modules/wizard/stores/main_store.dart';
import 'package:agendamento_vtr/app/modules/wizard/wizard_controller.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:agendamento_vtr/app/repositories/infra/constantes.dart';

class WizardModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => RepositoryAgenda(Api(Constantes.api, 'vtr/agenda'))),
    Bind.singleton((i) =>
        RepositoryTanqueAgendado(Api(Constantes.api, 'vtr/tanqueAgendado'))),
    Bind.singleton((i) => RepositoryTanque(Api(Constantes.api, 'vtr/tanque'))),
    Bind.singleton(
        (i) => RepositoryEmpresa(Api(Constantes.api, 'vtr/empresa'))),
    Bind.lazySingleton((i) => MainStore()),
    Bind.lazySingleton((i) => WizardController(Map())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
  ];
}
