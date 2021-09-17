import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class VisualizaTanqueDialog extends StatefulWidget {
  final Tanque tanque;

  VisualizaTanqueDialog(this.tanque);

  @override
  State<VisualizaTanqueDialog> createState() => _VisualizaTanqueDialogState();
}

class _VisualizaTanqueDialogState extends State<VisualizaTanqueDialog> {
  final formatoData = 'dd/MM/yy HH:mm';
  late Empresa proprietario;
  final tanquesRepo = Modular.get<Repository>();

  @override
  void initState() {
    super.initState();
    if (widget.tanque.proprietario != null) {
      tanquesRepo.findEmpresa(widget.tanque.proprietario!).then((value) => this.proprietario = value ?? Empresa());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = DateFormat(formatoData).format(widget.tanque.dataRegistro);
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
                widget.tanque.placa.replaceRange(3, 3, '-'),
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
                    proprietario.razaoSocial,
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
              child: proprietario.telefones.isNotEmpty
                  ? Row(
                      children: [
                        Text(
                          'Telefone ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          proprietario.telefones[0],
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )
                  : Text(
                      'Sem Telefone associado',
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
