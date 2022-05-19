import 'package:agendamento_vtr/app/modules/gru/stores/tanque_store.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository_municipio.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../repositories/infra/constantes.dart';
import 'main_page.dart';

class GruModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton(
        (i) => RepositoryTanque(Api(Constantes.api, Constantes.apiTanque))),
    Bind.singleton((i) =>
        RepositoryMunicipio(Api(Constantes.api, Constantes.apiMunicipios))),
    Bind((i) => TanqueStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
  ];
}
