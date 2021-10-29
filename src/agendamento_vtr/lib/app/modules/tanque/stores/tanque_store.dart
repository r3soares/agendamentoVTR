import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/validacoes.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque_model.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';

class TanqueStore extends StreamStore<Falha, ModelBase> {
  final cPlaca = StoreData<Tanque>(Tanque());
  final cInmetro = StoreData<Tanque>(Tanque());
  final cProprietario = StoreData<List<Tanque>>([]);
  final sTanque = StoreData<bool>(false);
  final sTanques = StoreData<bool>(false);
  final valida = Validacoes();
  final RepositoryTanque repo = Modular.get<RepositoryTanque>();
  final NumberFormat formato = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  TanqueStore() : super(TanqueModel(Tanque()));

  @override
  Future destroy() async {
    super.destroy();
    cPlaca.destroy();
    cInmetro.destroy();
    cProprietario.destroy();
    sTanque.destroy();
    sTanques.destroy();
  }

  //Esta salvando placa e codInmetro vazio!!!!!!!!!!!!!!
  salva(Tanque t) async {
    //status = TanqueStoreState.Salvando;
    sTanque.execute(() => repo.salvaTanque(t));
  }

  salvaMuitos(List<Tanque> lista) async {
    //status = TanqueStoreState.SalvandoMuitos;
    sTanques.execute(() => repo.salvaTanques(lista));
  }

  consultaInmetro(String inmetro) async {
    //status = TanqueStoreState.ConsultandoInmetro;
    //execute(() => repo.getTanque(inmetro));
    cInmetro.execute(() => repo.getTanque(inmetro));
  }

  consultaPlaca(String placa) async {
    //status = TanqueStoreState.ConsultandoPlaca;
    //execute(() => repo.findTanqueByPlaca(placa));
    cPlaca.execute(() => repo.findTanqueByPlaca(placa));
  }

  consultaProprietario(String proprietario) async {
    //status = TanqueStoreState.ConsultandoProprietario;
    //execute(() => repo.findTanquesByProprietario(proprietario));
    cProprietario.execute(() => repo.findTanquesByProprietario(proprietario));
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
