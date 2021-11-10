import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/domain/validacoes.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class TanqueStore {
  final cPlaca = StoreData<Tanque>(Tanque());
  final cInmetro = StoreData<Tanque>(Tanque());
  final cProprietario = StoreData<List<Tanque>>([]);
  final cEmpresa = StoreData<Empresa>(Empresa());
  final StoreData<bool> sTanque = StoreData<bool>(false);
  final sTanques = StoreData<bool>(false);
  final valida = Validacoes();
  final RepositoryEmpresa repoEmpresa = Modular.get<RepositoryEmpresa>();
  final RepositoryTanque repo = Modular.get<RepositoryTanque>();
  final NumberFormat formato = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  Future destroy() async {
    cPlaca.destroy();
    cInmetro.destroy();
    cProprietario.destroy();
    sTanque.destroy();
    sTanques.destroy();
  }

  salva(Tanque t) async {
    Log.message(this, 'Salvando... ${t.placa} | ${t.codInmetro}');
    sTanque.execute(() => repo.salvaTanque(t));
  }

  salvaMuitos(List<Tanque> lista) async {
    sTanques.execute(() => repo.salvaTanques(lista));
  }

  consultaInmetro(String inmetro) async {
    cInmetro.execute(() => repo.getTanque(inmetro));
  }

  consultaPlaca(String placa) async {
    cPlaca.execute(() => repo.findTanqueByPlaca(placa));
  }

  consultaEmpresa(String cnpj) {
    cEmpresa.execute(() => repoEmpresa.getEmpresa(cnpj));
  }

  double getCusto(List<Compartimento> compartimentos) {
    return compartimentos.fold(0, (acumulado, c) => acumulado + CustoCompartimento().getCusto(c.capacidade, c.setas));
  }

  double getCustoInidividual(Compartimento compartimento) {
    return CustoCompartimento().getCusto(compartimento.capacidade, compartimento.setas);
  }

  bool validaPlaca(String placa) {
    return valida.validaPlaca(placa);
  }
}
