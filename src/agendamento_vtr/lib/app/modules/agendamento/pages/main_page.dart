import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/main_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/agenda_do_dia_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/avisos_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/calendario2_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/tanque_agendado_selecionado_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/tanques_pendentes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ModularState<MainPage, MainStore> {
  @override
  void initState() {
    store.getAgendasOcupadas();
    store.getPendentes();
    store.getAgendados();
    super.initState();
  }

  @override
  void dispose() {
    //store.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('Reconstruindo Main Page');
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => {Modular.to.pushNamed('/cadastrados')},
                    child: Text(
                      'Veículos Cadastrados',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor),
                    )),
                const VerticalDivider(
                  color: Colors.white,
                  endIndent: 15,
                  indent: 15,
                ),
                TextButton(
                  onPressed: () =>
                      {Modular.to.pushNamed('/tanque/cadastroTanque')},
                  child: Text(
                    'Tanque',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
                TextButton(
                  onPressed: () => {Modular.to.pushNamed('/empresa/cadastro')},
                  child: Text(
                    'Empresa',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
                const VerticalDivider(
                  color: Colors.white,
                  endIndent: 15,
                  indent: 15,
                ),
                TextButton(
                  onPressed: () => {Modular.to.pushNamed('/gru')},
                  child: Text(
                    'GRU',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
                TextButton(
                  onPressed: () => {Modular.to.pushNamed('/wizard')},
                  child: Text(
                    'Cadastro de Solicitação',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 7,
              child: ScopedBuilder(
                store: store.storeAgendados,
                onState: (context, state) => Calendario2Widget(
                    agendados: state as List<
                        TanqueAgendado>), //CalendarioWidget(state as Map<String, Agenda>)),
                onLoading: (context) =>
                    Center(child: CircularProgressIndicator()),
                onError: (context, state) => Calendario2Widget(
                    agendados: state as List<
                        TanqueAgendado>), //CalendarioWidget(Map<String, Agenda>())),
              ),
            ),
            //PesquisaWidget(),
            Flexible(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ScopedBuilder(
                    store: store.storePendentes,
                    onState: (context, state) => Expanded(
                        flex: 2,
                        child: Card(
                            elevation: 12,
                            child: TanquesPendentesWidget(
                                state as List<TanqueAgendado>))),
                    onLoading: (context) => Expanded(
                        child: Center(child: CircularProgressIndicator())),
                    onError: (context, state) => Expanded(
                        flex: 2,
                        child: Card(
                            elevation: 12,
                            child: TanquesPendentesWidget(
                                List<TanqueAgendado>.empty()))),
                  ),
                  ScopedBuilder(
                    store: store.storeAgendado,
                    onState: (context, state) => Expanded(
                        flex: 3,
                        child: Card(
                            elevation: 12,
                            child: TanqueAgendadoSelecionadoWidget(
                                state as TanqueAgendado))),
                    onLoading: (context) => Expanded(
                        child: Center(child: CircularProgressIndicator())),
                  ),
                  Expanded(
                      flex: 2,
                      child: Card(elevation: 12, child: AvisosWidget())),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
