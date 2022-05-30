import 'package:agendamento_vtr/app/models/responsavel.dart';

import 'empresas.dart';

class Responsaveis {
  static List<Responsavel> responsaveis = List.empty(growable: true);

  Responsaveis() {
    if (responsaveis.isNotEmpty) return;
    Empresas();
    responsaveis = [
      Responsavel(
          '1', 'Fulano', '4733567448', 'ws@jm.com', Empresas.empresas[0]),
      Responsavel('2', 'Delcrano', '4736665598', 'ws@jm.com', null),
      Responsavel('3', 'Sicrano', '4833554742', 'ws@jm.com', null),
      Responsavel(
          '4', 'Belcrano', '4922369945', 'ws@jm.com', Empresas.empresas[2]),
      Responsavel('5', 'Mario', '4833652218', 'dfgt@jm.com', null),
      Responsavel(
          '6', 'Lailson', '4733567448', 'eedf@jm.com', Empresas.empresas[5]),
      Responsavel('7', 'Michael Jackson', '4733567448', 'vvgr@jm.com', null),
      Responsavel(
          '8', 'Xuxa', '4733567448', 'gbhh@jm.com', Empresas.empresas[7]),
      Responsavel(
          '9', 'Batman', '4733567448', 'ftgs@jm.com', Empresas.empresas[14]),
    ];
  }
}
