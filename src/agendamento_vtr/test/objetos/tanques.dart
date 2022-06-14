import 'dart:math';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';

import 'empresas.dart';

class Tanques {
  static const QUANTIDADE = 1000;
  static List<Tanque> tanques = List.empty(growable: true);
  static List<String> alfabeto = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'X',
    'Y',
    'Z'
  ];

  Tanques() {
    if (tanques.isNotEmpty) return;
    for (int i = 0; i < QUANTIDADE; i++) {
      Tanque t = Tanque();
      t.codInmetro = "$i";
      t.proprietario = Random().nextInt(10) > 7
          ? Empresas.empresas
              .elementAt(Random().nextInt(Empresas.empresas.length - 1))
          : null;
      t.placa = geraPlaca();
      for (int j = 0; j < Random().nextInt(10); j++) {
        t.compartimentos.add(Compartimento(j + 1));
        t.compartimentos[j].capacidade = Random().nextInt(50) * 100;
        t.compartimentos[j].setas = Random().nextInt(5);
      }
      t.dataUltimaAlteracao =
          DateTime.now().subtract(Duration(minutes: Random().nextInt(200000)));
      t.dataRegistro =
          DateTime.now().subtract(Duration(minutes: Random().nextInt(200000)));
      t.status = StatusTanque.values[Random().nextInt(2)];
      tanques.add(t);
    }
  }

  static String geraPlaca() =>
      alfabeto[Random().nextInt(alfabeto.length)] +
      alfabeto[Random().nextInt(alfabeto.length)] +
      alfabeto[Random().nextInt(alfabeto.length)] +
      Random().nextInt(10).toString() +
      Random().nextInt(10).toString() +
      Random().nextInt(10).toString() +
      Random().nextInt(10).toString();
}
