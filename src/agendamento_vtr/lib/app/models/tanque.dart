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

  StatusTanque status = StatusTanque.Ativo;

  List<Compartimento> compartimentos = List.empty(growable: true);

  final List<Arquivo> docs = List.empty(growable: true);

  int get capacidadeTotal => compartimentos.fold(0, (previousValue, element) => previousValue + element.capacidade);

  Tanque();

  get placaFormatada => placa.replaceRange(3, 3, '-');
  get totalSetas => compartimentos.fold(0, (int previousValue, element) => previousValue + element.setas);

  @override
  fromJson(Map<String, dynamic> json) => Tanque.fromJson(json);

  Tanque.fromJson(Map<String, dynamic> json)
      : placa = json['placa'],
        codInmetro = json['codInmetro'],
        proprietario = json['proprietario'],
        dataRegistro = DateTime.parse(json['dataRegistro']),
        dataUltimaAlteracao = DateTime.parse(json['dataUltimaAlteracao']),
        status = StatusTanque.values[json['status']],
        compartimentos = json['compartimentos'],
        custo = json['custo'];

  @override
  Map<String, dynamic> toJson() => {
        'placa': placa,
        'codInmetro': codInmetro,
        'proprietario': proprietario,
        'dataRegistro': dataRegistro.toIso8601String(),
        'dataUltimaAlteracao': dataUltimaAlteracao.toIso8601String(),
        'status': status.index,
        'compartimentos': compartimentos,
        'custo': custo,
      };
}

enum StatusTanque {
  Ativo,
  Inativo,
}
