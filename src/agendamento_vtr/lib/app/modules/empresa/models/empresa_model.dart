import 'package:agendamento_vtr/app/models/empresa.dart';

class EmpresaModel {
  final Status status;
  final Empresa empresa;

  EmpresaModel(this.status, this.empresa);
}

enum Status { Consulta, Salva, NaoSalva, Inicial }
