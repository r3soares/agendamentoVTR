import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TanqueStore {
  final RepositoryTanque repo = Modular.get<RepositoryTanque>();
  final StoreData<List<Tanque>> tanquesStore = StoreData([]);

  getTanquesByPlaca(String placa) {
    tanquesStore.execute(() => repo.findTanquesByPlacaParcial(placa));
  }

  getTanquesByInmetro(String inmetro) {
    tanquesStore.execute(() => repo.findTanquesByPlacaParcial(inmetro));
  }
}
