import 'package:agendamento_vtr/app/modules/agendamento/agenda_antiga_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/main_page.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/calendario_store.dart';
import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda_tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AgendamentoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => RepositoryAgenda(Api('agenda'))),
    Bind.singleton((i) => RepositoryAgendaTanque(Api('agendaTanque'))),
    Bind.singleton((i) => RepositoryTanque(Api('tanque'))),
    Bind.singleton((i) => RepositoryEmpresa(Api('empresa'))),
    Bind.lazySingleton((i) => CalendarioStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryAgendaTanque>())),
    Bind.singleton((i) => PesquisaController()),
    Bind.singleton((i) => AgendaAntigaStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
  ];
}
