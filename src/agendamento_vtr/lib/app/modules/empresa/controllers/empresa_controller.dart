import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpresaController {
  final repo = Modular.get<Repository>();

  Future<ModelBase> salvaEmpresa(Empresa e) async {
    try {
      return await repo.salvaEmpresa(e);
    } catch (e) {
      throw e;
    }
  }

  Future<Empresa?> findEmpresa({String? cnpj}) async {
    if (cnpj != null) {
      try {
        return (await repo.getEmpresa(cnpj)).model;
      } catch (e) {
        throw e;
      }
    }
  }
}
