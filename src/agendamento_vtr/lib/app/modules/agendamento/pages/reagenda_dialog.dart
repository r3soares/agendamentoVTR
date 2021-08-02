import 'package:agendamento_vtr/app/modules/agendamento/agenda_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/reagenda_widget.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ReagendaDialog extends StatelessWidget {
  final Tanque _tanque;
  const ReagendaDialog(this._tanque);

  @override
  Widget build(BuildContext context) {
    final dataAtual = _tanque.agenda!;
    final size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: size.width * .5,
        height: size.height * .6,
        child: Column(
          children: [
            ReagendaWidget(_tanque),
            ElevatedButton(
              onPressed: () => {
                reagendaTanque(dataAtual),
                Navigator.of(context).pop(),
              },
              child: Text('Agendar'),
            )
          ],
        ),
      ),
    );
  }

  void reagendaTanque(DateTime dataAntiga) {
    final agendaStore = Modular.get<AgendaStore>();
    agendaStore.mudaAgenda(dataAntiga, _tanque.agenda!, _tanque.placa);
  }
}
