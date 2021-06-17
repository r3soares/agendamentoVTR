import 'package:agendamento_vtr/app/modules/tanque/tanque_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TanqueModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => TanquePage()),
  ];
}
