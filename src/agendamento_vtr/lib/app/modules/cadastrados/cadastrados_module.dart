import 'package:agendamento_vtr/app/models/dado_psie.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/pages/main_page.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/stores/download_store.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/stores/empresa_store.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/stores/tanque_store.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_psie.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:agendamento_vtr/app/repositories/infra/constantes.dart';

class CadastradosModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton(
        (i) => RepositoryTanque(Api(Constantes.api, Constantes.apiTanque))),
    Bind.singleton(
        (i) => RepositoryEmpresa(Api(Constantes.api, Constantes.apiEmpresa))),
    Bind.singleton((i) => RepositoryPsie(Api(Constantes.scrap, '/placa'))),
    Bind.lazySingleton((i) => TanqueStore([])),
    Bind.lazySingleton((i) => EmpresaStore([])),
    Bind.lazySingleton(
        (i) => DownloadStore(DadoPsie('', '', '', '', '', '', '', '', '', ''))),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
    // ModuleRoute('/tanque', module: TanqueModule()),
    // ModuleRoute('/empresa', module: EmpresaModule()),
    // ModuleRoute('/gru', module: GruModule()),
  ];
}
