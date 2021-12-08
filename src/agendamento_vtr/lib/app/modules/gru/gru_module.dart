import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_municipio.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'main_page.dart';

class GruModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => RepositoryAgenda(Api('vtr/agenda'))),
    Bind.singleton((i) => RepositoryTanqueAgendado(Api('vtr/tanqueAgendado'))),
    Bind.singleton((i) => RepositoryTanque(Api('vtr/tanque'))),
    Bind.singleton((i) => RepositoryEmpresa(Api('vtr/empresa'))),
    Bind.singleton((i) => RepositoryMunicipio(Api('sgi/municipio'))),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
  ];
}
