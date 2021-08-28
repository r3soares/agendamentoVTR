import 'package:agendamento_vtr/app/models/tanque.dart';

class ValoresInstrumentos {
  final int id;
  final int portaria;
  final DateTime dataPortaria;
  final Map<int, double> custos;

  ValoresInstrumentos(this.id, this.portaria, this.dataPortaria, this.custos);

  double calculaCustos(Tanque tanque) {
    return 0;
  }
}
