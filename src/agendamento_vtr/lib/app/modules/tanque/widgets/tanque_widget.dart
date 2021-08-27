import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TanqueWidget extends StatefulWidget {
  final String placa;
  const TanqueWidget({Key? key, required this.placa}) : super(key: key);

  @override
  _TanqueWidgetState createState() => _TanqueWidgetState();
}

class _TanqueWidgetState extends State<TanqueWidget> {
  Tanque tanque = Tanque();

  @override
  void initState() {
    super.initState();
    tanque = Modular.get<Repository>().findTanque(widget.placa) ?? Tanque();
  }

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
              final prop = Modular.get<Empresa>();
              setState(() {
                prop.removeTanque(tanque.placa);
              });
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
