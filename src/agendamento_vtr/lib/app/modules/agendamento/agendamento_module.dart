import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/main_page.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/calendario_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/inclui_pendente_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/main_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/inclui_agendado_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/pesquisa_empresa_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/reagenda_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/tanques_pendentes_store.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/cadastrados_module.dart';
import 'package:agendamento_vtr/app/modules/empresa/empresa_module.dart';
import 'package:agendamento_vtr/app/modules/gru/gru_module.dart';
import 'package:agendamento_vtr/app/modules/tanque/stores/tanque_store.dart';
import 'package:agendamento_vtr/app/modules/tanque/tanque_module.dart';
import 'package:agendamento_vtr/app/modules/wizard/wizard_module.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_municipio.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:agendamento_vtr/app/repositories/infra/constantes.dart';

class AgendamentoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton(
        (i) => RepositoryAgenda(Api(Constantes.api, Constantes.apiAgenda))),
    Bind.singleton((i) => RepositoryTanqueAgendado(
        Api(Constantes.api, Constantes.apiTanqueAgendado))),
    Bind.singleton(
        (i) => RepositoryTanque(Api(Constantes.api, Constantes.apiTanque))),
    Bind.singleton(
        (i) => RepositoryEmpresa(Api(Constantes.api, Constantes.apiEmpresa))),
    Bind.singleton((i) =>
        RepositoryMunicipio(Api(Constantes.api, Constantes.apiMunicipios))),
    Bind.singleton((i) => AgendaController()),
    Bind.lazySingleton((i) => MainStore()),
    Bind.lazySingleton((i) => IncluiPendenteStore(
        Modular.get<RepositoryTanque>(),
        Modular.get<RepositoryTanqueAgendado>())),
    Bind.lazySingleton((i) => IncluiAgendadoStore(
        Modular.get<RepositoryAgenda>(),
        Modular.get<RepositoryTanqueAgendado>())),
    Bind.lazySingleton((i) => CalendarioStore(Modular.get<RepositoryAgenda>(),
        Modular.get<RepositoryTanqueAgendado>())),
    // Bind.lazySingleton(
    //     (i) => AgendaDoDiaStore(Modular.get<RepositoryAgenda>(), Modular.get<RepositoryTanqueAgendado>())),
    Bind.lazySingleton((i) => ReagendaStore(Modular.get<RepositoryAgenda>(),
        Modular.get<RepositoryTanqueAgendado>())),
    Bind.lazySingleton((i) => TanquesPendentesStore(
        Modular.get<RepositoryTanqueAgendado>(),
        Modular.get<RepositoryTanque>())),
    Bind.lazySingleton((i) => PesquisaEmpresaStore()),
    Bind.lazySingleton((i) => TanqueStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
    ModuleRoute('/tanque', module: TanqueModule()),
    ModuleRoute('/empresa', module: EmpresaModule()),
    ModuleRoute('/gru', module: GruModule()),
    ModuleRoute('/cadastrados', module: CadastradosModule()),
    ModuleRoute('/wizard', module: WizardModule()),
  ];
}
