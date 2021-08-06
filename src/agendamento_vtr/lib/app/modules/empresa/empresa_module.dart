import 'package:agendamento_vtr/app/modules/empresa/pages/cadastro_page.dart';
import 'package:agendamento_vtr/app/modules/empresa/pages/main_page.dart';
import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpresaModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => PesquisaController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
    ChildRoute('/cadastro',
        child: (_, args) => CadastroPage(preCadastro: args.data ?? '')),
  ];
}
