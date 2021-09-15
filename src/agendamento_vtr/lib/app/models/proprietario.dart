class Proprietario {
  int _cod = 0;
  String _empresa = '';
  int _codMunicipio = 0;
  final List<int> tanques = List.empty(growable: true);

  get empresa => _empresa;
  int get cod => _cod;
  int get codMunicipio => _codMunicipio;

  set empresa(value) => _empresa = value;
  set codInmetro(value) => _cod = value;
  set codMunicipio(value) => _codMunicipio = value;
}
