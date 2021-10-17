import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
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
    Bind.singleton((i) => AgendaController(Agenda(Constants.formatoData.format(DateTime.now())))),
    Bind.lazySingleton(
        (i) => CalendarioStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>())),
    Bind.lazySingleton(
        (i) => AgendaDoDiaStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>())),
    Bind.lazySingleton((i) => ReagendaStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>())),
    Bind.singleton((i) => PesquisaController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
  ];
}
