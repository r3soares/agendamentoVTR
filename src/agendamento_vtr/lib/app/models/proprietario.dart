import 'package:agendamento_vtr/app/models/tanque.dart';

class Proprietario {
  int codInmetro = 0;
  String empresa = '';
  int codMunicipio = 0;
  final List<Tanque> tanques = List.empty(growable: true);
}
