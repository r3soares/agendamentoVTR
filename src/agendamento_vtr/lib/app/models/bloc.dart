import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:flutter_triple/flutter_triple.dart';

class Bloc extends StreamStore<Falha, Object> {
  Bloc(initialState) : super(initialState as Object);

  @override
  update(Object data, {bool force = false}) {
    super.update(data, force: force);
  }
}
