import 'package:agendamento_vtr/app/domain/constants_agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_data_source.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/color_popup_widget.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      maxDate:
          DateTime.now().add(Duration(days: ConstantsAgenda.diascalendario)),
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
      allowAppointmentResize: false,
      timeSlotViewSettings: TimeSlotViewSettings(
          timeIntervalHeight: -1,
          timeFormat: 'HH',
          timeInterval: Duration(hours: ConstantsAgenda.tempoMinimoVeiculo),
          minimumAppointmentDuration:
              Duration(hours: ConstantsAgenda.tempoMinimoVeiculo),
          numberOfDaysInView: 5,
          startHour: ConstantsAgenda.horaInicio,
          endHour: ConstantsAgenda.horaFim),
      showCurrentTimeIndicator: true,
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
          padding: EdgeInsets.zero,
          decoration: _box(Color(appointment.statusCor)),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${appointment.tanque.resumoTanque} ${appointment.tanque.capacidadeTotal}L',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 1,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Flexible(
                    //     child: IconButton(
                    //         onPressed: () async =>
                    //             await _alteraCor(context, appointment),
                    //         icon: Icon(
                    //           Icons.color_lens_outlined,
                    //           color: Colors.black54,
                    //           size: 20,
                    //         )))
                  ],
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(color: Colors.white30),
                    padding: EdgeInsets.zero,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            color: Colors.black45,
                            constraints: const BoxConstraints.tightFor(
                                width: 20, height: 36),
                            iconSize: 18,
                            splashRadius: 8,
                            onPressed: () async =>
                                await _alteraCor(context, appointment),
                            icon: FaIcon(FontAwesomeIcons.p)),
                        IconButton(
                            color: Colors.black45,
                            constraints: const BoxConstraints.tightFor(
                                width: 20, height: 36),
                            iconSize: 18,
                            splashRadius: 8,
                            onPressed: () async =>
                                await _alteraCor(context, appointment),
                            icon: FaIcon(FontAwesomeIcons.d)),
                        IconButton(
                            color: Colors.black45,
                            constraints: const BoxConstraints.tightFor(
                                width: 20, height: 36),
                            iconSize: 18,
                            splashRadius: 8,
                            onPressed: () async =>
                                await _alteraCor(context, appointment),
                            icon: FaIcon(FontAwesomeIcons.v)),
                        IconButton(
                            color: Colors.black45,
                            constraints: const BoxConstraints.tightFor(
                                width: 20, height: 36),
                            iconSize: 18,
                            splashRadius: 8,
                            onPressed: () async =>
                                await _alteraCor(context, appointment),
                            icon: FaIcon(FontAwesomeIcons.i)),
                      ],
                    ),
                  )),
            ],
          ),
        );
      };

  _box(Color cor) => BoxDecoration(
        color: cor,
        border: Border.all(color: cor),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      );

  Future _showPopupColor(BuildContext context) async {
    return await showDialog<Color>(
        context: context,
        builder: (BuildContext context) {
          return ColorPopupWidget();
        });
  }

  _alteraCor(BuildContext context, TanqueAgendado ta) async {
    Color cor = await _showPopupColor(context);
    //print(cor);
    ta.statusCor = cor.value;
    await repoTa.save(ta);
    _controllerAgenda.notificaTanqueAgendadoAtualizado(ta);
    //controller.notifyPropertyChangedListeners(property)
  }
}
