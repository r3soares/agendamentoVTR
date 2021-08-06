import 'package:agendamento_vtr/app/modules/empresa/controllers/empresa_controller.dart';
import 'package:agendamento_vtr/app/modules/tanque/pages/main_page.dart';
import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'pages/cadastro_page.dart';

class TanqueModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => EmpresaController()),
    Bind.singleton((i) => PesquisaController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
    ChildRoute('/cadastro', child: (_, args) => CadastroPage()),
  ];
}
