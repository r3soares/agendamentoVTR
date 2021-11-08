import 'package:agendamento_vtr/app/domain/validacoes.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpresaStore {
  final valida = Validacoes();
  final StoreData<bool> sEmpresa = StoreData(false);
  final StoreData<Empresa> cEmpresa = StoreData(Empresa());
  final RepositoryEmpresa repo = Modular.get<RepositoryEmpresa>();
  EmpresaStore();

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
