import 'package:agendamento_vtr/app/modules/agendamento/models/estado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/municipio.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_municipio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MunicipiosACStore {
  final repo = Modular.get<RepositoryMunicipio>();
  final StoreData<Municipio> storeMun = StoreData(Municipio(Estado(0, '', ''), 0, 0, ''));
  final StoreData<List<Municipio>> storeLista = StoreData(List<Municipio>.empty());

  destroy() {
    storeMun.destroy();
    storeLista.destroy();
  }

  consultaCod(int cod) {
    storeMun.execute(() => repo.getMunicipio(cod));
  }

  consultaNome(String nome) {
    storeLista.execute(() => repo.findMunicipiosByNome(nome));
  }
}
