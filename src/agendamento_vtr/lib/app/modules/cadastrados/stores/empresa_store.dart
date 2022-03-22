import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class EmpresaStore extends StreamStore<Falha, List<Empresa>> {
  EmpresaStore(List<Empresa> initialState) : super(initialState);

  final RepositoryEmpresa _repoEmpresa = Modular.get<RepositoryEmpresa>();

  getEmpresas() async {
    execute(() => _repoEmpresa.getEmpresas());
  }
}
