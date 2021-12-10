import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/domain/extensions.dart';

class TanqueServico {
  final Tanque tanque;
  final CustoCompartimento custo;

  TanqueServico(this.tanque, this.custo);

  get placa => tanque.placaFormatada;
  get inmetro => tanque.codInmetro;
  get codProp => tanque.proprietario!.proprietario!.cod;
  get codMun => tanque.proprietario!.proprietario!.codMun;

  get geraCodigosServicos {
    Map<String, int> mapCodigos = {};
    int setas = 0;
    List<Compartimento> lista = tanque.compartimentos;
    lista.forEach((e) {
      String codCusto = custo.getCodServico(e.capacidade);
      mapCodigos.update(
        codCusto,
        (value) => ++value,
        ifAbsent: () => 1,
      );
      setas += e.setas;
    });
    List<String> valores = [];
    mapCodigos.forEach((key, value) {
      valores.add('$value x $key = R\$${custo.getCustoByCodServico(key).toStringAsFixed(2)}');
    });
    if (setas > 0) {
      valores.add('$setas x ${custo.codDispReferencial} = R\$${custo.custoSetas(setas).toStringAsFixed(2)}');
    }
    return valores.fold('', (previousValue, element) => '$previousValue\n$element');
  }
}
