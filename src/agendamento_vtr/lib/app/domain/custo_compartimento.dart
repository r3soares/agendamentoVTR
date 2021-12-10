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

  getCodServico(int cap) {
    if (cap <= 4000)
      return 361.toString();
    else if (cap <= 6000)
      return 362.toString();
    else if (cap <= 8000)
      return 363.toString();
    else if (cap <= 10000)
      return 364.toString();
    else if (cap <= 20000)
      return 365.toString();
    else if (cap <= 40000)
      return 366.toString();
    else //acima de 40.000L
      return 367.toString();
  }

  double getCustoByCodServico(String cod) {
    switch (cod) {
      case '361':
        return 187.86;
      case '362':
        return 222.65;
      case '363':
        return 296.41;
      case '364':
        return 371.55;
      case '365':
        return 743.11;
      case '366':
        return 1148.07;
      case '367':
        return 2268.31;
      case '368':
        return 180.90;
      default:
        return 0;
    }
  }

  get codDispReferencial => 368.toString();
}
