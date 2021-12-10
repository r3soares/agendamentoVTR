import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:agendamento_vtr/app/domain/extensions.dart';

class HistoricoTab extends StatefulWidget {
  final TanqueAgendado tAgendado;
  HistoricoTab(this.tAgendado);

  @override
  State<HistoricoTab> createState() => _HistoricoTabState();
}

class _HistoricoTabState extends State<HistoricoTab> {
  final ScrollController scrollController = ScrollController();
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
            child: SizedBox(
              height: 200,
              child: buildHistorico(historico.data!),
            ),
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

  buildCriacaoVeiculo(Tanque t) {
    return Card(
      elevation: 10,
      shadowColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Veículo criado:\n${t.dataRegistro.diaMesAnoToString()}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Última alteração:\n${t.dataUltimaAlteracao.diaMesAnoToString()}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '${t.obs ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  buildHistorico(List<TanqueAgendado> historico) {
    historico.sort((a, b) => a.dataRegistro.compareTo(b.dataRegistro));
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: ListView.builder(
          itemExtent: 200,
          physics: const ClampingScrollPhysics(),
          controller: scrollController,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: historico.length,
          itemBuilder: (BuildContext context, int i) {
            TanqueAgendado ta = historico.elementAt(i);
            var status = getStatusConfirmacao(ta);
            return Card(
              elevation: 10,
              shadowColor: Colors.black,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      '${ta.agenda == null ? 'Não agendado' : ta.agenda!.replaceAll('-', '/')}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${status.key}',
                        style: TextStyle(
                          fontSize: 16,
                          color: status.value,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${ta.obs ?? ''}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  MapEntry<String, Color> getStatusConfirmacao(TanqueAgendado ta) {
    var status = ta.statusConfirmacao;
    switch (status) {
      case StatusConfirmacao.PreAgendado:
        return MapEntry('Fila de Espera', Colors.deepPurple);
      case StatusConfirmacao.NaoConfirmado:
        return MapEntry('Não confirmou', Colors.orange);
      case StatusConfirmacao.Confirmado:
        return MapEntry('Verificado', Colors.green);
      case StatusConfirmacao.Reagendado:
        return MapEntry('Reagendado', Colors.blue.shade900);
      case StatusConfirmacao.Cancelado:
        return MapEntry('Cancelado', Colors.red);
    }
  }
}
