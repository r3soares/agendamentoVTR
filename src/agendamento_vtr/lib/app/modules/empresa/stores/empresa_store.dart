import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/empresa/models/empresa_model.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class EmpresaStore extends StreamStore<Falha, ModelBase> {
  final Repository repo = Modular.get<Repository>();
  EmpresaStore() : super(EmpresaModel(Status.Inicial, Empresa()));

  void salva(Empresa e) async {
    execute(() => repo.salvaEmpresa(e));
  }

  void consulta(String cnpj) async {
    execute(() => repo.getEmpresa(cnpj));
  }
}
