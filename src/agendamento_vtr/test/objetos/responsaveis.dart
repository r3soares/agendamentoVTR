import 'package:agendamento_vtr/app/models/responsavel.dart';

import 'empresas.dart';

class Responsaveis {
  static List<Responsavel> responsaveis = List.empty(growable: true);

  Responsaveis() {
    if (responsaveis.isNotEmpty) return;
    Empresas();
    responsaveis = [
      Responsavel('1', 'Fulano'),
      Responsavel('2', 'Delcrano'),
      Responsavel('3', 'Sicrano'),
      Responsavel('4', 'Belcrano'),
      Responsavel('5', 'Mario'),
      Responsavel('6', 'Lailson'),
      Responsavel('7', 'Michael Jackson'),
      Responsavel('8', 'Xuxa'),
      Responsavel('9', 'Batman'),
      Responsavel('10', 'Genomar'),
    ];
  }
}
