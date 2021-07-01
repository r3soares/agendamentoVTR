import 'package:agendamento_vtr/app/modules/tanque/models/proprietario.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';

class Repository {
  List<Tanque?> _tanques = List.empty(growable: true);
  List<Proprietario?> _proprietarios = List.empty(growable: true);

  List<Tanque?> get tanques => _tanques;
  List<Proprietario?> get proprietarios => _proprietarios;

  addTanque(value) => _tanques.add(value);
  addProprietario(value) => proprietarios.add(value);

  removeTanque(value) => _tanques.remove(value);
  removeProprietario(value) => _proprietarios.remove(value);

  Tanque? findTanque(String placa) =>
      _tanques.firstWhere((t) => t?.placa == placa, orElse: () => null);
  Proprietario? findProprietario(String cnpjCpf) =>
      _proprietarios.firstWhere((t) => t?.cnpj == cnpjCpf, orElse: () => null);
}
