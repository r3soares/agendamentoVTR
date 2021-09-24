import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class EmpresaStore extends StreamStore<Falha, Object> {
  final Repository repo = Modular.get<Repository>();
  EmpresaStore() : super(false);

  salva(Empresa e) async {
    execute(() => repo.salvaEmpresa(e));
  }

  consulta(String cnpj) async {
    execute(() => repo.getEmpresa(cnpj));
  }
}
