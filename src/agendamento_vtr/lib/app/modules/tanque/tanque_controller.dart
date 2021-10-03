import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class TanqueController {
  final _repo = Modular.get<RepositoryTanque>();

  final NumberFormat formato = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final CustoCompartimento _custo = CustoCompartimento();

  double getCusto(Compartimento c) {
    return _custo.getCusto(c.capacidade, c.setas);
  }

  Future<ModelBase> findTanqueByPlaca(String placa) async => await _repo.findTanqueByPlaca(placa);
  Future<ModelBase> findTanqueByinmetro(String inmetro) async => await _repo.getTanque(inmetro);

  void salvaTanque(Tanque t) {
    _repo.salvaTanque(t);
  }
}
