import 'package:agendamento_vtr/app/modules/tanque/models/proprietario.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TanqueWidget extends StatelessWidget {
  final Tanque tanque;
  const TanqueWidget({Key? key, required this.tanque}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 200,
          child: Card(
            borderOnForeground: true,
            elevation: 12,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('${tanque.placa}'),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('${calculaCapacidade()}L'),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child:
                      Text('${tanque.compartimentos.length} compartimento(s)'),
                ),
                tanque.compartimentos.any((element) => element.setas > 0)
                    ? Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Possui setas'),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          child: GestureDetector(
            onTap: () {
              final prop = Modular.get<Proprietario>();
              prop.removeTanque(tanque);
            },
            child: Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                )),
          ),
        ),
      ],
    );
  }

  int calculaCapacidade() {
    int total = tanque.compartimentos.fold(
        0, (previousValue, element) => previousValue + element.capacidade);
    return total;
  }
}
