import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/json_serializable.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';

class Tanque implements JsonSerializable {
  String placa = '';
  String codInmetro = '';

  //empresa que possui o proprietario
  Empresa? proprietario;

  DateTime dataRegistro = DateTime.now();
  DateTime dataUltimaAlteracao = DateTime.now();

  String? obs;

  StatusTanque status = StatusTanque.Ativo;

  List<Compartimento> compartimentos = List.empty(growable: true);

  final List<Arquivo> docs = List.empty(growable: true);

  int get capacidadeTotal => compartimentos.fold(0, (previousValue, element) => previousValue + element.capacidade);

  Tanque();

  get placaFormatada => placa.replaceRange(3, 3, '-');
  get totalSetas => compartimentos.fold(0, (int previousValue, element) => previousValue + element.setas);

  get custoTotal {
    final CustoCompartimento custo = CustoCompartimento();
    var capacidades = compartimentos.map((e) => e.capacidade).toList();
    int setas = compartimentos.fold(0, (p, e) => p + e.setas);
    return custo.getCustoTotal(capacidades, setas);
  }

  @override
  fromJson(Map<String, dynamic> json) => Tanque.fromJson(json);

  Tanque.fromJson(Map<String, dynamic> json)
      : placa = json['placa'],
        codInmetro = json['codInmetro'],
        proprietario = json['proprietario'] == null ? null : Empresa.fromJson(json['proprietario']),
        dataRegistro = DateTime.parse(json['dataRegistro']),
        dataUltimaAlteracao = DateTime.parse(json['dataUltimaAlteracao']),
        status = StatusTanque.values[json['status']],
        compartimentos = json['compartimentos'],
        obs = json['obs'] == null ? null : json['obs'];

  @override
  Map<String, dynamic> toJson() => {
        'placa': placa,
        'codInmetro': codInmetro,
        'proprietario': proprietario == null ? null : proprietario!.toJson(),
        'dataRegistro': dataRegistro.toIso8601String(),
        'dataUltimaAlteracao': dataUltimaAlteracao.toIso8601String(),
        'status': status.index,
        'compartimentos': compartimentos,
        'obs': obs
      };

  @override
  toString() {
    return '$placaFormatada ($codInmetro)';
  }
}

enum StatusTanque {
  Ativo,
  Inativo,
}
