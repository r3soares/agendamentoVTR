import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PesquisaEmpresaStore {
  final RepositoryEmpresa repoEmpresa = Modular.get<RepositoryEmpresa>();
  StoreData<List<Empresa>> empresasStore = StoreData([]);

  getEmpresasByNome(String nome) {
    empresasStore.execute(() => repoEmpresa.findEmpresasByNome(nome));
  }

  getEmpresasByCNPJ(String cnpjParcial) {
    empresasStore.execute(() => repoEmpresa.findEmpresasByCNPJParcial(cnpjParcial));
  }
}
