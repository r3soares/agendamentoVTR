import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/calendario_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioWidget extends StatefulWidget {
  final Bloc diaAtual;
  const CalendarioWidget({Key? key, required this.diaAtual}) : super(key: key);

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
  Map<DateTime, Agenda> agendasOcupadas = {};
  Map<String, AgendaTanque> agendasTanque = {};
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

    // store.blocDiaAtual.observer(onState: (e) {
    //   ModelBase m = e as ModelBase;
    //   widget.diaAtual.update(m.model);
    // });
    // store.alteraDiaAtual(kToday);

    store.agendasTanque.observer(onState: (e) {
      ModelBase m = e as ModelBase;
      for (AgendaTanque at in m.model) {
        agendasTanque[at.id] = at;
      }
    });

    store.agendasOcupadas.observer(onState: (e) {
      ModelBase m = e as ModelBase;
      agendasOcupadas.clear();
      for (Agenda a in m.model) {
        agendasOcupadas[a.data] = a;
      }
      store.listaAgendasTanque(agendasOcupadas.entries.map((e) => e.value.id).toList());
    });
    store.listaAgendasOcupadas(kFirstDay, kLastDay);
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
          widget.diaAtual.update(selectedDay);
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

        // print(focusedDay);

        // setState(() {
        //   kFirstDay = focusedDay.subtract(Duration(days: 31));
        //   kLastDay = focusedDay.add(Duration(days: 31));
        // });

        store.alteraDiaAtual(focusedDay);
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
    if (agendasOcupadas.containsKey(dia)) {
      var agenda = agendasOcupadas[dia];
      if (agenda != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${dia.day}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    agenda.tanquesAgendados.length,
                    (index) =>
                        agendasTanque[agenda.tanquesAgendados[index]]!.statusConfirmacao == StatusConfirmacao.Confirmado
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
      decoration: new BoxDecoration(
        color: Colors.deepPurple,
        shape: BoxShape.circle,
      ),
      child: Text(
        'Hoje',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
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
