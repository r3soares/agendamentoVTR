import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/municipio.dart';
import 'package:agendamento_vtr/app/domain/extensions.dart';

class TanqueServico {
  final List<Tanque> tanques;
  final CustoCompartimento custo;
  final Map<int, Municipio> mapMunicipios;

  TanqueServico(this.tanques, this.custo, this.mapMunicipios);

  getPlaca(int index) => tanques[index].placa;
  getInmetro(int index) => tanques[index].codInmetro;
  getProp(int index) {
    Empresa prop = tanques[index].proprietario!;
    return '${prop.proprietario!.cod}\n${prop.razaoSocial}';
  }

  getMun(int index) {
    var codMun = tanques[index].proprietario!.proprietario!.codMun;
    var municipio = mapMunicipios[codMun];
    return '$codMun\n${municipio!.noMunicipio.toLowerCase().toTitleCase()}';
  }

  getCustoTotal(int index) => _getCustoTotal(tanques[index].compartimentos);

  geraCodigosServicos(int index) {
    Map<String, int> mapCodigos = {};
    int setas = 0;
    List<Compartimento> lista = tanques[index].compartimentos;
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
      valores.add('$value x $key = R\$ ${(custo.getCustoByCodServico(key) * value).toStringAsFixed(2)}');
    });
    if (setas > 0) {
      valores.add('$setas x ${custo.codDispReferencial} = R\$ ${custo.custoSetas(setas).toStringAsFixed(2)}');
    }
    return valores.fold('', (previousValue, element) => '$previousValue\n$element');
  }

  double _getCustoTotal(List<Compartimento> compartimentos) {
    var capacidades = compartimentos.map((e) => e.capacidade).toList();
    int setas = compartimentos.fold(0, (p, e) => p + e.setas);
    return custo.getCustoTotal(capacidades, setas);
  }
}
