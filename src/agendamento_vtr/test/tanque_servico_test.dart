import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/modules/gru/models/tanque_servico.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Cálculos de custo do TanqueServico', () async {
    final custoCompartimento = CustoCompartimento();

    var repoTanque = RepositoryTanque(Api('vtr/tanque'));
    var tanques = await repoTanque.getTanques();

    for (var i = 0; i < 50; i++) {
      var ts = TanqueServico(tanques[i], custoCompartimento);
      print(ts.geraCodigosServicos);
    }
  });
}
