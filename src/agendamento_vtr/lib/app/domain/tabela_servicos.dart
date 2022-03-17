import 'package:agendamento_vtr/app/domain/servico_vtr.dart';

class TabelaServicos {
  final String nome;
  final List<ServicoVtr> servicos;
  bool atual = false;
  final DateTime data;

  TabelaServicos(this.nome, this.servicos, this.data);
}
