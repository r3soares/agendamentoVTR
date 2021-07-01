import 'package:flutter_triple/flutter_triple.dart';

class AgendaStore extends NotifierStore<Exception, DateTime> {
  get agendamento => state.year;
  AgendaStore() : super(DateTime.now());
}
