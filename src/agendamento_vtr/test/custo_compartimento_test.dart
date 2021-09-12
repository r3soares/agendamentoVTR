import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Cálculos de custo', () {
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
    const List<int> compartimentos1 = [5000, 5000, 3000, 2000, 5000, 5000];
    //6 compartimentos
    //6x5000
    const double tanque2 = 1335.90;
    List<int> compartimentos2 = [5000, 5000, 5000, 5000, 5000, 5000];
    //7 compartimentos
    //7500 7500 5000 5000 5000 5000 5000
    const double tanque3 = 1706.07;
    const List<int> compartimentos3 = [7500, 7500, 5000, 5000, 5000, 5000, 5000];
    //1 compartimento 4 setas
    //45000
    const double tanque4 = 2991.91;

    //9 compartimentos
    //7500 7500 5000 5000 5000 5000 5000 5000 5000
    const double tanque5 = 2151.37;
    const List<int> compartimentos5 = [7500, 7500, 5000, 5000, 5000, 5000, 5000, 5000, 5000];
    //5 compartimentos
    //5000 5000 5000 4000 3500
    const double tanque6 = 1043.67;
    const List<int> compartimentos6 = [5000, 5000, 5000, 4000, 3500];

    final custoCompartimento = CustoCompartimento();

    expect(custoCompartimento.getCustoTotal(compartimentos1, 0), equals(tanque1));
    expect(custoCompartimento.getCustoTotal(compartimentos2, 0), equals(tanque2));
    expect(custoCompartimento.getCustoTotal(compartimentos3, 0), equals(tanque3));
    expect(custoCompartimento.getCusto(45000, 4), equals(tanque4));
    expect(custoCompartimento.getCustoTotal(compartimentos5, 0), equals(tanque5));
    expect(custoCompartimento.getCustoTotal(compartimentos6, 0), equals(tanque6));
  });
}
