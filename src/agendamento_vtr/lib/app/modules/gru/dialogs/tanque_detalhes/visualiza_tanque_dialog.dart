import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/gru/dialogs/tanque_detalhes/empresas_associadas_tab.dart';
import 'package:agendamento_vtr/app/modules/gru/dialogs/tanque_detalhes/obs_tab.dart';
import 'package:agendamento_vtr/app/modules/gru/dialogs/tanque_detalhes/tanque_tab.dart';
import 'package:flutter/material.dart';

class VisualizaTanqueDialog extends StatelessWidget {
  final Tanque tanque;
  final index;

  VisualizaTanqueDialog(this.tanque, {this.index = 0});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 80, horizontal: 250),
        child: DefaultTabController(
          initialIndex: index,
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('${tanque.placaFormatada} (${tanque.codInmetro})'),
              bottom: TabBar(
                tabs: [
                  Tab(child: Text('Empresa Associada')),
                  Tab(child: Text('Tanque')),
                  Tab(child: Text('Anotações'))
                ],
              ),
            ),
            body: TabBarView(
              children: [
                EmpresasAssociadasTab(tanque),
                TanqueTab(tanque),
                ObsTab(tanque),
              ],
            ),
          ),
        ));
  }
}
