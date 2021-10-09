import 'package:agendamento_vtr/app/modules/agendamento/agenda_antiga_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/main_page.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/agenda_do_dia_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/calendario_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/reagenda_store.dart';
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
    Bind.lazySingleton(
        (i) => CalendarioStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>())),
    Bind.lazySingleton((i) => AgendaDoDiaStore(
        Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>(), Modular.get<RepositoryTanque>())),
    Bind.lazySingleton((i) => ReagendaStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>())),
    Bind.singleton((i) => PesquisaController()),
    Bind.singleton((i) => AgendaAntigaStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
  ];
}
