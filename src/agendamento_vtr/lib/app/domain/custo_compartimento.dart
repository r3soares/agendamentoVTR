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

    custoSetas = setas * 180.9;

    return custoCompartimento + custoSetas;
  }
}
