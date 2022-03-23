import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/dado_psie.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_municipio.dart';
import 'package:agendamento_vtr/app/repositories/repository_psie.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class DownloadStore extends StreamStore<Falha, DadoPsie> {
  DownloadStore(DadoPsie initialState) : super(initialState);

  final RepositoryPsie _repoPsie = Modular.get<RepositoryPsie>();
  final RepositoryTanque _repoTanque = Modular.get<RepositoryTanque>();
  final RepositoryEmpresa _repoEmpresa = Modular.get<RepositoryEmpresa>();
  final RepositoryMunicipio _repoMun = Modular.get<RepositoryMunicipio>();

  download(String placa) async {
    execute(() => _repoPsie.getPlaca(placa));
  }

  getPlacaLocal(String placa) async {
    try {
      var tanque = await _repoTanque.findTanqueByPlaca(placa);
      return tanque;
    } catch (e) {
      return null;
    }
  }

  getEmpresaLocal(String cnpj) async {
    try {
      var empresa = await _repoEmpresa.getEmpresa(cnpj);
      return empresa;
    } catch (e) {
      return null;
    }
  }

  getMunicipio(String nomeMun) async {
    try {
      var municipio = (await _repoMun.findMunicipiosByNome(nomeMun)).first;
      return municipio;
    } catch (e) {
      return null;
    }
  }
}
