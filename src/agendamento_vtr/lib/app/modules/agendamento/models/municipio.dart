import 'package:agendamento_vtr/app/models/json_serializable.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/estado.dart';

class Municipio implements JsonSerializable {
  final Estado unfId;
  final int munId;
  final int cdMunicipio;
  final String noMunicipio;

  Municipio(this.unfId, this.munId, this.cdMunicipio, this.noMunicipio);

  @override
  fromJson(Map<String, dynamic> json) => Municipio.fromJson(json);

  Municipio.fromJson(Map<String, dynamic> json)
      : unfId = Estado.fromJson(json['unfId']),
        munId = json['munId'],
        cdMunicipio = json['cdMunicipio'],
        noMunicipio = json['noMunicipio'];

  @override
  Map<String, dynamic> toJson() => {
        'unfId': unfId.toJson(),
        'munId': munId,
        'cdMunicipio': cdMunicipio,
        'noMunicipio': noMunicipio,
      };

  @override
  String toString() {
    return '[$cdMunicipio] $noMunicipio (${unfId.sgUf})';
  }
}
