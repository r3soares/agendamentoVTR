import 'package:agendamento_vtr/app/modules/empresa/stores/empresa_store.dart';
import 'package:agendamento_vtr/app/modules/tanque/pages/main_page.dart';
import 'package:agendamento_vtr/app/modules/tanque/pages/tanque_page.dart';
import 'package:agendamento_vtr/app/modules/tanque/stores/tanque_store.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'pages/cadastro_page.dart';

class TanqueModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => RepositoryTanque(Api('vtr/tanque'))),
    Bind.factory((i) => TanqueStore()),
    Bind.factory((i) => EmpresaStore())
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
    ChildRoute('/cadastro', child: (_, args) => CadastroPage()),
    ChildRoute('/cadastroTanque',
        child: (_, args) => TanquePage(
              tanquePrevio: args.data,
            )),
  ];
}
