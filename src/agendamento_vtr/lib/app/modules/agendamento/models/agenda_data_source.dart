import 'package:agendamento_vtr/app/domain/constants_agenda.dart';
import 'package:agendamento_vtr/app/domain/extensions.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AgendaDataSource extends CalendarDataSource<TanqueAgendado> {
  late List<int> horarios;
  AgendaDataSource(List<TanqueAgendado> source) {
    appointments = source;
    horarios = [];
    for (int i = ConstantsAgenda.horaInicio.toInt();
        i < ConstantsAgenda.horaFim.toInt();
        i += ConstantsAgenda.tempoMinimoVeiculo) {
      horarios.add(i);
    }
  }

  DateTime _getEncaixe(DateTime? horarioOriginal) {
    if (horarioOriginal == null) return DateTime.now();
    for (int i = 0; i < horarios.length; i++) {
      if (horarioOriginal.hour > horarios[i]) continue;
      var novoHorario = DateTime(horarioOriginal.year, horarioOriginal.month,
          horarioOriginal.day, horarios[i]);
      return novoHorario;
    }
    return DateTime.now();
  }

  @override
  DateTime getStartTime(int index) {
    return _getEncaixe(appointments![index].dataInicio);
  }

  @override
  DateTime getEndTime(int index) {
    return _getEncaixe(appointments![index].dataFim);
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
