import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/validacoes.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque_model.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class TanqueStore extends StreamStore<Falha, ModelBase> {
  final valida = Validacoes();
  final Repository repo = Modular.get<Repository>();
  TanqueStoreState status = TanqueStoreState.Inicial;
  TanqueStore() : super(TanqueModel(Status.Inicial, Tanque()));

  //Esta salvando placa e codInmetro vazio!!!!!!!!!!!!!!
  salva(Tanque t) async {
    status = TanqueStoreState.Salvando;
    execute(() => repo.salvaTanque(t));
  }

  salvaMuitos(List<Tanque> lista) async {
    status = TanqueStoreState.SalvandoMuitos;
    execute(() => repo.salvaTanques(lista));
  }

  consultaInmetro(String inmetro) async {
    status = TanqueStoreState.ConsultandoInmetro;
    execute(() => repo.getTanque(inmetro));
  }

  consultaPlaca(String placa) async {
    status = TanqueStoreState.ConsultandoPlaca;
    execute(() => repo.findTanqueByPlaca(placa));
  }

  consultaProprietario(String proprietario) async {
    status = TanqueStoreState.ConsultandoProprietario;
    execute(() => repo.findTanquesByProprietario(proprietario));
  }

  double getCusto(List<Compartimento> compartimentos) {
    return compartimentos.fold(0, (acumulado, c) => acumulado + CustoCompartimento().getCusto(c.capacidade, c.setas));
  }

  bool validaPlaca(String placa) {
    return valida.validaPlaca(placa);
  }
}

enum TanqueStoreState {
  Inicial,
  Salvando,
  SalvandoMuitos,
  ConsultandoPlaca,
  ConsultandoInmetro,
  ConsultandoProprietario
}
