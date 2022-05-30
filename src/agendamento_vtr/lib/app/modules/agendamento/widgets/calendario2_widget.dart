import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendario2Widget extends StatelessWidget {
  const Calendario2Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
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
      timeSlotViewSettings: const TimeSlotViewSettings(numberOfDaysInView: 5),
      monthViewSettings: MonthViewSettings(
          showAgenda: true,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }
}
