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
    var ts = TanqueServico(tanques, custoCompartimento, {});
    for (var i = 0; i < 50; i++) {
      print(ts.geraCodigosServicos(i));
    }
  });
}
