import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/main_page.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/calendario_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/main_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/pesquisa_agenda_do_dia_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/reagenda_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/tanques_pendentes_store.dart';
import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AgendamentoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => RepositoryAgenda(Api('agenda'))),
    Bind.singleton((i) => RepositoryTanqueAgendado(Api('tanqueAgendado'))),
    Bind.singleton((i) => RepositoryTanque(Api('tanque'))),
    Bind.singleton((i) => RepositoryEmpresa(Api('empresa'))),
    Bind.singleton((i) => AgendaController()),
    Bind.lazySingleton((i) => MainStore()),
    Bind.lazySingleton(
        (i) => PesquisaAgendaDoDiaStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>())),
    Bind.lazySingleton(
        (i) => CalendarioStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>())),
    // Bind.lazySingleton(
    //     (i) => AgendaDoDiaStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>())),
    Bind.lazySingleton((i) => ReagendaStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>())),
    Bind.lazySingleton(
        (i) => TanquesPendentesStore(Modular.get<RepositoryTanqueAgendado>(), Modular.get<RepositoryTanque>())),
    Bind.singleton((i) => PesquisaController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
  ];
}
