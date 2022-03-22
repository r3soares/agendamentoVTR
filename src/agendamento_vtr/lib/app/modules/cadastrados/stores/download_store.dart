import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/dado_psie.dart';
import 'package:agendamento_vtr/app/repositories/repository_psie.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class DownloadStore extends StreamStore<Falha, DadoPsie> {
  DownloadStore(DadoPsie initialState) : super(initialState);

  final RepositoryPsie _repoPsie = Modular.get<RepositoryPsie>();

  download(String placa) async {
    execute(() => _repoPsie.getPlaca(placa));
  }
}
