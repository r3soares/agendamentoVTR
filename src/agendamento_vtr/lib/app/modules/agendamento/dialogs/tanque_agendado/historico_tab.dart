import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HistoricoTab extends StatefulWidget {
  final TanqueAgendado tAgendado;
  HistoricoTab(this.tAgendado);

  @override
  State<HistoricoTab> createState() => _HistoricoTabState();
}

class _HistoricoTabState extends State<HistoricoTab> {
  final RepositoryTanque repoTanque = Modular.get<RepositoryTanque>();

  @override
  initState() {
    super.initState();
  }

  Future<List<TanqueAgendado>> getHistorico() async {
    try {
      return await repoTanque.getHistorico(widget.tAgendado.tanque.codInmetro);
    } on Falha catch (e) {
      throw e; //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao obter histórico: ${e.msg}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHistorico(),
      builder: (BuildContext context, AsyncSnapshot<List<TanqueAgendado>> historico) {
        if (historico.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (historico.hasData) {
          return Center(
            child: buildHistorico(historico.data!),
          );
        }
        if (historico.hasError) {
          Falha e = historico.error as Falha;
          return Center(
            child: Text(e.msg),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  buildHistorico(List<TanqueAgendado> historico) {}
}
