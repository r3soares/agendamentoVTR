import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/validacoes.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/empresa/models/empresa_model.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class EmpresaStore extends StreamStore<Falha, ModelBase> {
  final valida = Validacoes();
  final Bloc sEmpresa = Bloc(ModelBase(null));
  final Bloc cEmpresa = Bloc(ModelBase(null));
  final RepositoryEmpresa repo = Modular.get<RepositoryEmpresa>();
  EmpresaStore() : super(EmpresaModel(Empresa()));

  void salva(Empresa e) async {
    sEmpresa.execute(() => repo.salvaEmpresa(e));
  }

  void consulta(String cnpj) async {
    cEmpresa.execute(() => repo.getEmpresa(cnpj));
  }

  bool validaEmail(String email) {
    return valida.validaEmail(email);
  }

  bool validaTelefone(String telefone) {
    return valida.validaTelefone(telefone);
  }
}
