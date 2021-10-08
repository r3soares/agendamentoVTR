import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/extensions.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_model.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/calendario_store.dart';
import 'package:agendamento_vtr/app/widgets/base_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioWidget extends BaseWidgets {
  final BlocAgendaModel diaAtual;
  CalendarioWidget({Key? key, required this.diaAtual});

  @override
  _CalendarioWidgetState createState() => _CalendarioWidgetState();
}

class _CalendarioWidgetState extends ModularState<CalendarioWidget, CalendarioStore> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final kToday = DateTime.now();
  late DateTime kFirstDay;
  late DateTime kLastDay;
  Map<String, AgendaModel> agendas = {};
  // Map<String, Agenda> agendasOcupadas = {};
  // Map<String, TanqueAgendado> tanquesAgendados = {};
  final bolinhaNaoConfirmado = Container(
      margin: EdgeInsets.all(1),
      width: 5.0,
      height: 5.0,
      decoration: new BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ));

  final bolinhaConfirmado = Container(
      margin: EdgeInsets.all(1),
      width: 5.0,
      height: 5.0,
      decoration: new BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ));

  _CalendarioWidgetState() {
    kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
    kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);
    _selectedDay = kToday;
  }

  @override
  void initState() {
    super.initState();
    widget.diaAtual.observer(
        onState: (agendaModel) => setState(() {
              agendas[agendaModel.agenda.data] = agendaModel;
            }));
    store.observer(
      onState: (e) => setState(() {
        agendas = e.model;
        print('Encontrado ${agendas.length} agendas');
      }),
      onLoading: loading,
    );
    store.getAgendasOcupadasNova(Constants.formatoData.format(kFirstDay), Constants.formatoData.format(kLastDay));

    store.blocDiaAtual.observer(onState: (e) => _notificaAgendaSelecionada((e as ModelBase).model));
    store.getAgendaDoDia(kToday.diaMesAnoToString(), agendas);
  }

  loading(bool isLoading) {
    widget.loading(isLoading, context);
  }

  void _notificaAgendaSelecionada(Agenda a) {
    AgendaModel am = agendas.containsKey(a.data) ? agendas[a.data]! : AgendaModel(a, List.empty(growable: true));
    widget.diaAtual.update(am);
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      rangeSelectionMode: RangeSelectionMode.disabled,
      headerStyle: HeaderStyle(formatButtonVisible: false),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mês',
        CalendarFormat.twoWeeks: '2 Semanas',
        CalendarFormat.week: 'Semana'
      },
      startingDayOfWeek: StartingDayOfWeek.monday,
      locale: 'pt_BR',
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        // Use `selectedDayPredicate` to determine which day is currently selected.
        // If this returns true, then `day` will be marked as selected.

        // Using `isSameDay` is recommended to disregard
        // the time-part of compared DateTime objects.
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          store.getAgendaDoDia(selectedDay.diaMesAnoToString(), agendas);
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          // Call `setState()` when updating calendar format
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        _focusedDay = focusedDay;
      },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday || day.weekday == DateTime.saturday) {
            final text = DateFormat.E('pt_BR').format(day);
            return Center(
              child: Text(
                text,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
        },
        defaultBuilder: (context, day, focusedDay) => diaWidget(day),
        selectedBuilder: (context, day, focusedDay) => diaSelecionadoWidget(day),
        todayBuilder: (context, day, focusedDay) => hojeWidget(day),
      ),
    );
  }

  Widget diaWidget(DateTime dia) {
    if (agendas.containsKey(dia.diaMesAnoToString())) {
      var agendaModel = agendas[dia.diaMesAnoToString()];
      if (agendaModel != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${dia.day}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    agendaModel.agendados.length,
                    (index) => agendaModel.agendados[index].statusConfirmacao == StatusConfirmacao.Confirmado
                        ? bolinhaConfirmado
                        : bolinhaNaoConfirmado),
              )
            ],
          ),
        );
      }
    }
    return Center(
      child: Text('${dia.day}'),
    );
  }

  Widget hojeWidget(DateTime dia) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '${dia.day}',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget diaSelecionadoWidget(DateTime dia) {
    return Container(
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
      ),
      child: Text(
        '${dia.day}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
