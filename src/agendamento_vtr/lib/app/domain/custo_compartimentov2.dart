import 'package:agendamento_vtr/app/domain/extensions.dart';
import 'package:agendamento_vtr/app/domain/servico_vtr.dart';

class CustoCompartimentoV2 {
  late ServicoVtr servicoSeta;
  late List<ServicoVtr> servicos;

  CustoCompartimentoV2(List<ServicoVtr> servicosVtr) {
    servicoSeta = servicosVtr.removeAt(0);
    servicos = servicosVtr;
  }

  double getCusto(int cap, int setas) {
    if (cap == 0) return 0;
    double custoCompartimento =
        servicos.firstWhere((s) => cap <= s.capacidadeMaxima).valor;

    double custoSetas = setas > 0 ? this.custoSetas(setas) : 0;

    return (custoCompartimento + custoSetas).toPrecision(2);
  }

  double custoSetas(int setas) =>  setas * servicoSeta.valor;

  double getCustoTotal(List<int> caps, int setas) {
    double custoCompartimento = 0;
    double custoSetas = 0;
    for (var c in caps) {
      custoCompartimento += getCusto(c, 0);
    }
    custoSetas = this.custoSetas(setas);
    return (custoCompartimento + custoSetas).toPrecision(2);
  }

  getCodServico(int cap) =>
      servicos.firstWhere((s) => cap <= s.capacidadeMaxima).cod.toString();

  double getCustoByCodServico(String cod) =>
      servicos.firstWhere((s) => cod == s.cod.toString()).valor;

  get codDispReferencial => servicoSeta.cod.toString();
}
