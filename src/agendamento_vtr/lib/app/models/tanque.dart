import 'package:agendamento_vtr/app/models/custo_tanque.dart';
import 'package:agendamento_vtr/app/models/json_serializable.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';

class Tanque implements JsonSerializable {
  String placa = '';
  String codInmetro = '';

  //CNPJ da empresa que possui o proprietario
  String? proprietario;

  double custo = 0;
  DateTime dataRegistro = DateTime.now();
  DateTime dataUltimaAlteracao = DateTime.now();

  String? tanqueAgendado;

  StatusTanque status = StatusTanque.Ativo;

  List<Compartimento> compartimentos = [Compartimento(1)];
  //Tem que remover
  DateTime? agenda; //Tem que remover
  String? responsavelAgendamento; //Tem que remover
  //remover daqui
  bool isZero = false;

  final List<Arquivo> docs = List.empty(growable: true);

  int get capacidadeTotal => compartimentos.fold(0, (previousValue, element) => previousValue + element.capacidade);

  Tanque();
  @override
  fromJson(Map<String, dynamic> json) => Tanque.fromJson(json);

  Tanque.fromJson(Map<String, dynamic> json)
      : placa = json['Placa'],
        codInmetro = json['CodInmetro'],
        proprietario = json['Proprietario'],
        dataRegistro = json['DataRegistro'],
        dataUltimaAlteracao = json['DataUltimaAlteracao'],
        tanqueAgendado = json['TanqueAgendado'],
        status = StatusTanque.values[json['Status']],
        compartimentos = List.from(json['Compartimentos']),
        custo = json['Custo'];

  @override
  Map<String, dynamic> toJson() => {
        'Placa': placa,
        'CodInmetro': codInmetro,
        'Proprietario': proprietario,
        'DataRegistro': dataRegistro,
        'DataUltimaAlteracao': dataUltimaAlteracao,
        'TanqueAgendado': tanqueAgendado,
        'Status': status.index,
        'Compartimentos': compartimentos,
        'Custo': custo,
      };
}

enum StatusTanque {
  Ativo,
  Inativo,
}
