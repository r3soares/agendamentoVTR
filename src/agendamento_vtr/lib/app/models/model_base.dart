class ModelBase {
  final model;
  final Status status;

  ModelBase(this.status, this.model);
}

enum Status { Consulta, ConsultaMuitos, ConsultaPlaca, ConsultaInmetro, Salva, NaoSalva, Inicial }
