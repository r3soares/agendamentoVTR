import 'dart:typed_data';

import 'package:agendamento_vtr/app/modules/tanque/arquivo.dart';

class Tanque {
  final String placa;
  final bool isZero;
  final Arquivo doc;
  final Map<int, List<int>> compartimentos;

  Tanque(this.placa, this.isZero, this.doc, this.compartimentos);
}
