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
    return appointments![index].dataInicio;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].dataFim;
  }

  @override
  String getSubject(int index) {
    return '${appointments![index].tanque.resumoTanque} ${appointments![index].tanque.capacidadeTotal}L';
  }

  @override
  Color getColor(int index) {
    return Colors.green;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }

  @override
  TanqueAgendado? convertAppointmentToObject(
      TanqueAgendado? customData, Appointment appointment) {
    var tAgendado = TanqueAgendado(
      id: appointment.id.toString(),
      tanque: customData!.tanque,
      agenda: appointment.startTime.diaMesAnoToString(),
    );
    tAgendado.dataInicio = appointment.startTime;
    tAgendado.dataFim = appointment.endTime;
    return tAgendado;
  }
}
