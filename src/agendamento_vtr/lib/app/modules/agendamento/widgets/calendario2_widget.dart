import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_data_source.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendario2Widget extends StatelessWidget {
  final List agendados;
  final CalendarController controller = CalendarController();
  final AgendaController _controllerAgenda = Modular.get<AgendaController>();
  final RepositoryTanqueAgendado repoTa =
      Modular.get<RepositoryTanqueAgendado>();
  Calendario2Widget({Key? key, required this.agendados}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      controller: controller,
      dataSource: AgendaDataSource(agendados as List<TanqueAgendado>),
      maxDate: DateTime.now().add(Duration(days: 730)),
      view: CalendarView.workWeek,
      showDatePickerButton: true,
      allowedViews: <CalendarView>[
        CalendarView.day,
        CalendarView.week,
        CalendarView.workWeek,
        CalendarView.month,
        CalendarView.schedule
      ],
      allowDragAndDrop: true,
      firstDayOfWeek: 1, // Monday
      showNavigationArrow: true,
      allowAppointmentResize: true,
      timeSlotViewSettings: const TimeSlotViewSettings(
          timeIntervalHeight: -1,
          timeFormat: 'HH:mm',
          timeInterval: const Duration(hours: 1),
          minimumAppointmentDuration: const Duration(hours: 1),
          numberOfDaysInView: 5,
          startHour: 8,
          endHour: 19),
      showCurrentTimeIndicator: false,
      monthViewSettings: MonthViewSettings(
        showAgenda: false,
        appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        agendaViewHeight: 400,
      ),
      onDragEnd: onChangeAgendamento,
      onTap: onTap,
      appointmentBuilder: appointementBuilder,
    );
  }

  onChangeAgendamento(AppointmentDragEndDetails agendamento) async {
    var tAgendado = agendamento.appointment as TanqueAgendado;
    print(tAgendado.agenda);
    await repoTa.save(tAgendado);
    _controllerAgenda.notificaTanqueAgendadoAtualizado(
        agendamento.appointment as TanqueAgendado);
  }

  onTap(CalendarTapDetails detalhes) {
    if (detalhes.targetElement == CalendarElement.appointment ||
        detalhes.targetElement == CalendarElement.agenda) {
      final TanqueAgendado tAgendado = detalhes.appointments![0];
      // var agenda = _controllerAgenda.storeAgendas.data[tAgendado.agenda];
      // print(tAgendado.agenda);
      // _controllerAgenda.notificaDiaAtualizado(agenda!);
      _controllerAgenda.notificaTanqueAgendadoAtualizado(tAgendado);
    }
  }

  get appointementBuilder => (BuildContext context,
          CalendarAppointmentDetails calendarAppointmentDetails) {
        final TanqueAgendado appointment =
            calendarAppointmentDetails.appointments.first;
        return Container(
          decoration: _box,
          child: Text(
            '${appointment.tanque.resumoTanque} ${appointment.tanque.capacidadeTotal}L',
            textAlign: TextAlign.center,
            style: TextStyle(
              wordSpacing: 2,
              letterSpacing: 1,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      };

  get _box => BoxDecoration(
        color: Colors.green,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      );
}
