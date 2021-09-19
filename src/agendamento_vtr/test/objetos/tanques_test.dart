import 'dart:math';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';

class TanquesTest {
  List<Tanque> tanques = List.empty(growable: true);

  TanquesTest() {
    final alfabeto = [
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
    for (int i = 0; i < Random().nextInt(500) + 15; i++) {
      Tanque t = Tanque();
      t.codInmetro = "${Random().nextInt(alfabeto.length)}$i";
      t.proprietario = '00970455941';
      t.placa = alfabeto[Random().nextInt(alfabeto.length)] +
          alfabeto[Random().nextInt(alfabeto.length)] +
          alfabeto[Random().nextInt(alfabeto.length)] +
          Random().nextInt(10).toString() +
          Random().nextInt(10).toString() +
          Random().nextInt(10).toString() +
          Random().nextInt(10).toString();
      for (int j = 0; j < Random().nextInt(10); j++) {
        t.compartimentos.add(Compartimento(j + 1));
        t.compartimentos[j].capacidade = Random().nextInt(50) * 100;
        t.compartimentos[j].setas = Random().nextInt(5);
      }
      t.dataUltimaAlteracao = DateTime.now().subtract(Duration(minutes: Random().nextInt(200000)));
      t.dataRegistro = DateTime.now().subtract(Duration(minutes: Random().nextInt(200000)));
      t.custo = (Random().nextDouble() * 5000);
      t.status = StatusTanque.values[Random().nextInt(2)];
      tanques.add(t);
    }
  }
}
