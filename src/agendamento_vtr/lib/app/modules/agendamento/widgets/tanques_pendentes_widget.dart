import 'package:agendamento_vtr/app/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class TanquesPendentesWidget extends StatelessWidget {
  final tanques =
      Modular.get<Repository>().tanques.where((t) => t?.agenda == null);
  TanquesPendentesWidget({Key? key}) : super(key: key);
  final formatoData = 'dd/MM/yy (HH:mm)';

  @override
  Widget build(BuildContext context) {
    return tanques.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: tanques.length,
            itemBuilder: (BuildContext context, int index) {
              final data = DateFormat(formatoData)
                  .format(tanques.elementAt(index)!.dataRegistro);
              return Center(
                  child: Text('$data : ${tanques.elementAt(index)?.placa}'));
            },
          )
        : Text('Não há tanques pendentes de agendamento');
  }
}
