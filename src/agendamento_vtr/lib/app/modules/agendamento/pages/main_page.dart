import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/main_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/agenda_do_dia_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/avisos_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/calendario_widget.dart';
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
                IconButton(
                  onPressed: () => {Modular.to.pushNamed('/tanque/cadastroTanque')},
                  icon: Icon(Icons.add_road),
                  splashRadius: 5,
                ),
                IconButton(
                  onPressed: () => {Modular.to.pushNamed('/empresa/cadastro')},
                  icon: Icon(Icons.add_business),
                  splashRadius: 5,
                ),
                TextButton(
                  onPressed: () => {Modular.to.pushNamed('/gru')},
                  child: Text(
                    'GRU',
                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 5,
              child: SingleChildScrollView(
                child: ScopedBuilder(
                  store: store.storeAgendas,
                  onState: (context, state) =>
                      Card(elevation: 12, child: CalendarioWidget(state as Map<String, Agenda>)),
                  onLoading: (context) => Center(child: CircularProgressIndicator()),
                ),
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
                        child: Card(elevation: 12, child: TanquesPendentesWidget(state as List<TanqueAgendado>))),
                    onLoading: (context) => Expanded(child: Center(child: CircularProgressIndicator())),
                  ),
                  ScopedBuilder(
                    store: store.storeDiaAtualizado,
                    onState: (context, state) =>
                        Expanded(flex: 3, child: Card(elevation: 12, child: AgendaDoDiaWidget(state as Agenda))),
                    onLoading: (context) => Expanded(child: Center(child: CircularProgressIndicator())),
                  ),
                  Expanded(flex: 2, child: Card(elevation: 12, child: AvisosWidget())),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
