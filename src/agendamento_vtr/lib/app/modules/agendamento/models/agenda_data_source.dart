import 'package:agendamento_vtr/app/domain/constants_agenda.dart';
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
    return appointments![index].dataInicio ?? DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].dataFim ?? DateTime.now();
  }

  @override
  String getSubject(int index) {
    return '${appointments![index].tanque.resumoTanque} ${appointments![index].tanque.capacidadeTotal}L';
  }

  @override
  Color getColor(int index) {
    return Color(appointments![index].statusCor);
  }

  @override
  bool isAllDay(int index) {
    return false;
  }

  @override
  TanqueAgendado? convertAppointmentToObject(
      TanqueAgendado? customData, Appointment appointment) {
    customData!.dataInicio = appointment.startTime;
    customData.dataFim = appointment.endTime;
    var dif = appointment.endTime.difference(appointment.startTime).inHours;
    if (dif < ConstantsAgenda.tempoMinimoVeiculo) {
      customData.dataFim = appointment.startTime
          .add(Duration(hours: ConstantsAgenda.tempoMinimoVeiculo));
    }
    customData.statusCor = appointment.color.value;
    customData.agenda = appointment.startTime.diaMesAnoToString();
    return customData;
  }
}
