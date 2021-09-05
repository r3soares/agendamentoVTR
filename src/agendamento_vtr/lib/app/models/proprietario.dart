class Proprietario {
  final int cod;
  final String empresa;
  int codMunicipio = 0;
  final List<int> tanques = List.empty(growable: true);

  Proprietario(this.cod, this.empresa);
}
