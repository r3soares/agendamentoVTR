import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainStore {
  StoreData<List<Tanque>> get sTanque => StoreData([]);
  StoreData<List<Empresa>> get sEmpresa => StoreData([]);

  final RepositoryTanque _repoTanque = Modular.get<RepositoryTanque>();
  final RepositoryEmpresa _repoEmpresa = Modular.get<RepositoryEmpresa>();

  getTanques() async {
    //await Future.delayed(Duration(seconds: 5));
    sTanque.execute(() => _repoTanque.getTanques());
  }

  getEmpresas() async {
    //await Future.delayed(Duration(seconds: 1));
    sEmpresa.execute(() => _repoEmpresa.getEmpresas());
  }
}
