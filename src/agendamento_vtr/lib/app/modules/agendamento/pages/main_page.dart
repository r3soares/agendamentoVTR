import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_model.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/agenda_do_dia_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/calendario_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/pesquisa_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BlocAgendaModel blocDiaAtual = BlocAgendaModel(AgendaModel(Agenda(""), List.empty()));

    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamentos'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          CalendarioWidget(
            diaAtual: blocDiaAtual,
          ),
          PesquisaWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Card(elevation: 12, child: TanquesPendentesWidget()),
              ScopedBuilder(
                store: blocDiaAtual,
                onState: (context, e) => Card(
                    elevation: 12,
                    child: AgendaDoDiaWidget(
                      blocAgendaModel: blocDiaAtual,
                    )),
              )
              //Card(elevation: 12, child: AgendaDoDiaWidget()),
              //Card(elevation: 12, child: TanquesAgendadosWidget()),
            ],
          )
        ]),
      ),
    );
  }
}
