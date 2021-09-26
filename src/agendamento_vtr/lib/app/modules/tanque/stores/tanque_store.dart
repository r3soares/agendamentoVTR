import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque_model.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class TanqueStore extends StreamStore<Falha, ModelBase> {
  final Repository repo = Modular.get<Repository>();
  TanqueStore() : super(TanqueModel(Status.Inicial, Tanque()));

  //Esta salvando placa e codInmetro vazio!!!!!!!!!!!!!!
  salva(Tanque t) async {
    execute(() => repo.salvaTanque(t));
  }

  consultaInmetro(String inmetro) async {
    execute(() => repo.getTanque(inmetro));
  }

  consultaPlaca(String placa) async {
    execute(() => repo.findTanqueByPlaca(placa));
  }
}
