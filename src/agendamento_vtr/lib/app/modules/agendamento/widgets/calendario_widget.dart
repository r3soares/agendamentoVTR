import 'dart:math';

import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/extensions.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_model.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/calendario_store.dart';
import 'package:agendamento_vtr/app/widgets/base_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioWidget extends BaseWidgets {
  CalendarioWidget({Key? key});

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
    store.blocDiaAtualizado.observer(
        onState: (aModel) => {
              print('Dia Atualizado ${aModel.agenda.data}: ${aModel.agendados.length} agendados'),
              agendas[aModel.agenda.data] = aModel,
              if (mounted) setState(() {}),
            });
    store.observer(
      onState: (e) => {
        agendas = e.model,
        //print('Encontrado ${agendas.length} agendas'),
        if (mounted) setState(() {}),
      },
      onLoading: loading,
    );
    store.getAgendasOcupadas(Constants.formatoData.format(kToday), Constants.formatoData.format(kLastDay));
    store.getAgendaDoDia(kToday.diaMesAnoToString(), agendas);
  }

  loading(bool isLoading) {
    widget.loading(isLoading, context);
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
        //holidayBuilder: (context, day, focusedDay) => _feriado(day),
        defaultBuilder: (context, day, focusedDay) => diaWidget(day),
        selectedBuilder: (context, day, focusedDay) => diaSelecionadoWidget(day),
        todayBuilder: (context, day, focusedDay) => hojeWidget(day),
      ),
    );
  }

  Widget diaWidget(DateTime dia) {
    if (_isPassado(dia)) return _diaPassado(dia);
    if (agendas.containsKey(dia.diaMesAnoToString())) {
      var agendaModel = agendas[dia.diaMesAnoToString()];
      if (agendaModel != null) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(6),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${dia.day}',
                  style: TextStyle(color: _getColorAgenda(agendaModel.agenda.status)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(agendaModel.agendados.length,
                      (index) => _bolinhaWidget(agendaModel.agendados[index].statusConfirmacao)),
                )
              ],
            ),
          ),
        );
      }
    }
    if (_isFeriado(dia)) return _feriado(dia);
    if (_isFimDeSemana(dia)) return _fimDeSemana(dia);
    return Center(
      child: Container(
        margin: const EdgeInsets.all(6),
        alignment: Alignment.center,
        child: Text(
          '${dia.day}',
          style: TextStyle(color: _getColorByDiaSemana(dia.weekday)),
        ),
      ),
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
      margin: const EdgeInsets.all(2),
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

  Widget _diaPassado(DateTime dia) {
    return Center(
      child: Text(
        '${dia.day}',
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }

  Widget _fimDeSemana(DateTime dia) {
    return Center(
      child: Text(
        '${dia.day}',
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }

  Widget _feriado(DateTime dia) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Feriado',
          style: TextStyle(color: Colors.brown[500]),
        ),
        Text(
          '${dia.day}',
          style: TextStyle(color: Colors.brown[500]),
        ),
      ],
    ));
  }

  Color _getColorAgenda(StatusAgenda status) {
    switch (status) {
      case StatusAgenda.Disponivel:
        return Colors.green.shade700;
      case StatusAgenda.Cheia:
        return Colors.red.shade300;
      case StatusAgenda.Encerrada:
        return Colors.grey.shade500;
      case StatusAgenda.Indisponivel:
        return Colors.grey.shade500;
    }
  }

  Color _getColorByDiaSemana(int diaSemana) {
    switch (diaSemana) {
      case 6:
        return Colors.grey.shade500;
      case 7:
        return Colors.grey.shade500;
      default:
        return Colors.green.shade700;
    }
  }

  bool _isPassado(DateTime dia) {
    return kToday.compareTo(dia) > 1;
  }

  bool _isFimDeSemana(DateTime dia) {
    return dia.weekday > 5;
  }

  //Implementar
  bool _isFeriado(DateTime dia) => Random().nextInt(100) > 95;

  Widget _bolinhaWidget(StatusConfirmacao status) => Container(
      margin: EdgeInsets.all(1),
      width: 5.0,
      height: 5.0,
      decoration: new BoxDecoration(
        color: _getCorConfirmacao(status),
        shape: BoxShape.circle,
      ));

  Color _getCorConfirmacao(StatusConfirmacao status) {
    switch (status) {
      case StatusConfirmacao.NaoConfirmado:
        return Colors.orange;
      case StatusConfirmacao.Confirmado:
        return Colors.green;
      case StatusConfirmacao.Reagendado:
        return Colors.blue.shade900;
      case StatusConfirmacao.Cancelado:
        return Colors.red;
    }
  }
}
