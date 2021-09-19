import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpresaController {
  final repo = Modular.get<Repository>();

  salvaEmpresa(Empresa e) {
    repo.salvaEmpresa(e);
  }

  Future<Empresa?> findEmpresa({String? cnpj}) async {
    if (cnpj != null) return await repo.getEmpresa(cnpj);
  }
}
