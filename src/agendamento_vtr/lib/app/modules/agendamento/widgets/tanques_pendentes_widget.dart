import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:agendamento_vtr/app/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class TanquesPendentesWidget extends StatelessWidget {
  final tanques = Modular.get<Repository>()
      .tanques
      .where((t) => t?.agenda == null)
      .toList();

  TanquesPendentesWidget({Key? key}) : super(key: key);
  final formatoData = 'dd/MM/yy HH:mm';

  @override
  Widget build(BuildContext context) {
    tanques.sort((a, b) => a!.dataRegistro.compareTo(b!.dataRegistro));
    return tanques.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: tanques.length,
            itemBuilder: (BuildContext context, int index) {
              Tanque t = tanques.elementAt(index)!;
              final data = DateFormat(formatoData).format(t.dataRegistro);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 12,
                  child: ListTile(
                    leading: Icon(Icons.drive_eta_outlined),
                    title: Row(children: [
                      Text(
                        t.placa.replaceRange(3, 3, '-'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '${t.capacidadeTotal.toString()}L (${t.compartimentos.length}C)',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ]),
                    subtitle: Text('$data'),
                    trailing: TextButton(
                      child: Text('Agendar'),
                      onPressed: () => {},
                    ),
                  ),
                ),
              );
            },
          )
        : Text('Não há tanques pendentes de agendamento');
  }
}
