import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:agendamento_vtr/app/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class VisualizaTanqueDialog extends StatelessWidget {
  final Tanque _tanque;
  final formatoData = 'dd/MM/yy HH:mm';
  final tanquesRepo = Modular.get<Repository>();

  VisualizaTanqueDialog(this._tanque);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final proprietario = _tanque.proprietario != null
        ? tanquesRepo.findProprietario(_tanque.proprietario!)
        : null;
    final data = DateFormat(formatoData).format(_tanque.dataRegistro);
    return Dialog(
      child: Container(
        width: size.width * .3,
        height: size.height * .3,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.topCenter,
              child: Text(
                _tanque.placa.replaceRange(3, 3, '-'),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    'Proprietário ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    proprietario!.razaoSocial,
                    style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    'Contato ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    proprietario.email,
                    style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: proprietario.oficina != null
                  ? Row(
                      children: [
                        Text(
                          'Oficina ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          proprietario.oficina!,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )
                  : Text(
                      'Sem Oficina associada',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(top: 12, right: 8),
              child: Text(
                'Registrado em $data',
                style: TextStyle(fontSize: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
