import 'package:agendamento_vtr/app/domain/extensions.dart';

class CustoCompartimento {
  double getCusto(int cap, int setas) {
    if (cap == 0) return 0;
    double custoCompartimento = 0;
    double custoSetas = 0;
    if (cap <= 4000)
      custoCompartimento = 187.86;
    else if (cap <= 6000)
      custoCompartimento = 222.65;
    else if (cap <= 8000)
      custoCompartimento = 296.41;
    else if (cap <= 10000)
      custoCompartimento = 371.55;
    else if (cap <= 20000)
      custoCompartimento = 743.11;
    else if (cap <= 40000)
      custoCompartimento = 1148.07;
    else //acima de 40.000L
      custoCompartimento = 2268.31;

    custoSetas = setas > 0 ? this.custoSetas(setas) : 0;

    return (custoCompartimento + custoSetas).toPrecision(2);
  }

  double custoSetas(int setas) {
    return setas * 180.9;
  }

  double getCustoTotal(List<int> caps, int setas) {
    double custoCompartimento = 0;
    double custoSetas = 0;
    for (var c in caps) {
      custoCompartimento += getCusto(c, 0);
    }
    custoSetas = this.custoSetas(setas);
    return (custoCompartimento + custoSetas).toPrecision(2);
  }
}
