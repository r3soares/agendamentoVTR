import 'package:agendamento_vtr/app/domain/extensions.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AgendaDataSource extends CalendarDataSource<TanqueAgendado> {
  AgendaDataSource(List<TanqueAgendado> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return DateFormat('dd-MM-yyyy').parse(appointments![index].agenda);
  }

  @override
  DateTime getEndTime(int index) {
    return DateFormat('dd-MM-yyyy').parse(appointments![index].agenda);
  }

  @override
  String getSubject(int index) {
    return appointments![index].tanque.resumoTanque;
  }

  @override
  Color getColor(int index) {
    return Colors.green;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  @override
  TanqueAgendado? convertAppointmentToObject(
      TanqueAgendado? customData, Appointment appointment) {
    return TanqueAgendado(
        id: appointment.id.toString(),
        tanque: customData!.tanque,
        agenda: appointment.startTime.diaMesAnoToString());
  }
}
