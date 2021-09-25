import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/empresa/models/empresa_model.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpresaController {
  final repo = Modular.get<Repository>();

  Future<bool> salvaEmpresa(Empresa e) async {
    try {
      return (await repo.salvaEmpresa(e)).status == Status.Salva;
    } catch (e) {
      throw e;
    }
  }

  Future<Empresa?> findEmpresa({String? cnpj}) async {
    if (cnpj != null) {
      try {
        return (await repo.getEmpresa(cnpj)).empresa;
      } catch (e) {
        throw e;
      }
    }
  }
}
