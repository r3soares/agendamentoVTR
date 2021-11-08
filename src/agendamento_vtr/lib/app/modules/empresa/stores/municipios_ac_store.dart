import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/estado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/municipio.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_municipio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class MunicipiosACStore extends StreamStore<Falha, List<Municipio>> {
  final repo = Modular.get<RepositoryMunicipio>();
  final StoreData<Municipio> storeMun = StoreData(Municipio(Estado(0, '', ''), 0, 0, ''));

  MunicipiosACStore(initialState) : super(initialState);

  consultaCod(int cod) {
    storeMun.execute(() => repo.getMunicipio(cod));
  }

  consultaNome(String nome) {
    execute(() => repo.findMunicipiosByNome(nome));
  }
}
