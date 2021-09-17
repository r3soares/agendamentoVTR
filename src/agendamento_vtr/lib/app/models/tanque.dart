import 'package:agendamento_vtr/app/models/custo_tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';

class Tanque {
  String placa = '';
  String numInmetro = '';

  //CNPJ da empresa que possui o proprietario
  String? proprietario;
  bool isZero = false;

  DateTime dataRegistro = DateTime.now();
  DateTime dataUltimaAlteracao = DateTime.now();

  String? tanqueAgendado;

  StatusTanque status = StatusTanque.Ativo;

  List<Compartimento> compartimentos = [Compartimento('C1')];

  Arquivo? doc; //Tem que remover
  DateTime? agenda; //Tem que remover
  String? responsavelAgendamento; //Tem que remover
  CustoTanque? ultimoCusto;

  final List<Arquivo> docs = List.empty(growable: true);

  int get capacidadeTotal => compartimentos.fold(
      0, (previousValue, element) => previousValue + element.capacidade);
}

enum StatusTanque {
  Ativo,
  Inativo,
}
