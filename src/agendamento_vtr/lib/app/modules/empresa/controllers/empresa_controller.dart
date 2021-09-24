import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpresaController {
  final repo = Modular.get<Repository>();

  Future<bool> salvaEmpresa(Empresa e) async {
    try {
      return repo.salvaEmpresa(e);
    } catch (e) {
      throw e;
    }
  }

  Future<Empresa?> findEmpresa({String? cnpj}) async {
    if (cnpj != null) {
      try {
        return await repo.getEmpresa(cnpj);
      } catch (e) {
        throw e;
      }
    }
  }
}
