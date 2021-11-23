import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/pesquisa_empresa_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/agendamentos_tab.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/empresas_associadas_tab.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/status_tab.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/tanque_tab.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VisualizaTanqueAgendadoDialog extends StatelessWidget {
  final TanqueAgendado tAgendado;

  VisualizaTanqueAgendadoDialog(this.tAgendado);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 80, horizontal: 250),
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(child: Text('Empresas Associadas')),
                  Tab(child: Text('Tanque')),
                  Tab(child: Text('Status')),
                  Tab(child: Text('Histórico'))
                ],
              ),
            ),
            body: TabBarView(
              children: [
                EmpresasAssociadasTab(tAgendado),
                TanqueTab(tAgendado),
                StatusTab(tAgendado),
                AgendamentoTab(tAgendado),
              ],
            ),
          ),
        ));
  }
}
