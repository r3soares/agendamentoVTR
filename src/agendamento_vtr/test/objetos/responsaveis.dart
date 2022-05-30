import 'package:agendamento_vtr/app/models/responsavel.dart';

import 'empresas.dart';

class Responsaveis {
  static List<Responsavel> responsaveis = List.empty(growable: true);

  Responsaveis() {
    if (responsaveis.isNotEmpty) return;
    Empresas();
    responsaveis = [
      Responsavel('1', 'Fulano', '4733567448', 'ws@jm.com', 'Idasa', null),
      Responsavel('2', 'Delcrano', '4736665598', 'ws@jm.com', 'Idasa', ''),
      Responsavel('3', 'Sicrano', '4833554742', 'ws@jm.com', 'Dalcoquio',
          'Nada a declarar'),
      Responsavel('4', 'Belcrano', '4922369945', 'ws@jm.com', null, null),
      Responsavel(
          '5', 'Mario', '4833652218', 'dfgt@jm.com', 'Cooper Liquidos', ''),
      Responsavel('6', 'Lailson', '4733567448', 'eedf@jm.com', null, ''),
      Responsavel(
          '7', 'Michael Jackson', '4733567448', 'vvgr@jm.com', 'Idasa', null),
      Responsavel('8', 'Xuxa', '4733567448', 'gbhh@jm.com', 'Transpetro', ''),
      Responsavel('9', 'Batman', '4733567448', 'ftgs@jm.com', '', null),
    ];
  }
}
