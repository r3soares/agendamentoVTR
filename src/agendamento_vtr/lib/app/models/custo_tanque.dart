import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/models/valores_instrumentos.dart';

class CustoTanque {
  final String id = '';
  final DateTime dataCalculo = DateTime.now();
  late String placaTanque;
  late int idTabelaCusto;
  late double custo;

  CustoTanque(
      {required ValoresInstrumentos tabelaCustos, required Tanque tanque}) {
    placaTanque = tanque.placa;
    idTabelaCusto = tabelaCustos.id;
    custo = tabelaCustos.calculaCustos(tanque);
  }
}
