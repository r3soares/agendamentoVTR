import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:intl/intl.dart';

class TanqueController {
  final NumberFormat formato =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final CustoCompartimento _custo = CustoCompartimento();
  double getCusto(Compartimento c) {
    return _custo.getCusto(c.capacidade, c.setas);
  }
}
