import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:flutter_triple/flutter_triple.dart';

class BlocAgendaModel extends StreamStore<Falha, Agenda> {
  BlocAgendaModel(initialState) : super(initialState);

  @override
  update(Agenda data, {bool force = false}) {
    super.update(data, force: force);
  }

  @override
  setError(Falha erro, {bool force = false}) {
    super.setError(erro, force: force);
  }
}
