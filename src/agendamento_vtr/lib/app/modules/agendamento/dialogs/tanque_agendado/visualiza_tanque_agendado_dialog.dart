import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/historico_tab.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/empresas_associadas_tab.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/status_tab.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/tanque_tab.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter/material.dart';

class VisualizaTanqueAgendadoDialog extends StatelessWidget {
  final TanqueAgendado tAgendado;
  final index;

  VisualizaTanqueAgendadoDialog(this.tAgendado, {this.index = 0});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 80, horizontal: 250),
        child: DefaultTabController(
          initialIndex: index,
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('${tAgendado.tanque.placaFormatada} (${tAgendado.tanque.codInmetro})'),
              bottom: TabBar(
                tabs: [
                  Tab(child: Text('Empresas Associadas')),
                  Tab(child: Text('Tanque')),
                  Tab(child: Text('Histórico'))
                ],
              ),
            ),
            body: TabBarView(
              children: [
                EmpresasAssociadasTab(tAgendado),
                TanqueTab(tAgendado),
                HistoricoTab(tAgendado),
              ],
            ),
          ),
        ));
  }
}
