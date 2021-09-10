import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Valida calculos de custo', () {
    // const double custoSeta = 180.9;
    // const double c4000 = 187.86;
    // const double c6000 = 222.65;
    // const double c8000 = 296.41;
    // const double c10000 = 371.55;
    // const double c20000 = 743.11;
    // const double c40000 = 1148.07;
    // const double c40000M = 2268.31;

    //6 compartimentos
    //5000 5000 3000 2000 5000 5000
    const double tanque1 = 1266.32;

    //6 compartimentos
    //6x5000
    const double tanque2 = 1335.90;

    //7 compartimentos
    //7500 7500 5000 5000 5000 5000 5000
    const double tanque3 = 1706.07;

    //1 compartimento 4 setas
    //45000
    const double tanque4 = 2991.91;

    //9 compartimentos
    //7500 7500 5000 5000 5000 5000 5000 5000 5000
    const double tanque5 = 2151.37;

    //5 compartimentos
    //5000 5000 5000 4000 3500
    const double tanque6 = 1043.67;

    final custoCompartimento = CustoCompartimento();

    expect(custoCompartimento.getCusto(45000, 4), equals(tanque4));
  });
}
