import 'package:agendamento_vtr/app/modules/tanque/models/compartimento.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompartimentoWidget extends StatefulWidget {
  final Compartimento compartimento;
  const CompartimentoWidget({Key? key, required this.compartimento})
      : super(key: key);

  @override
  _CompartimentoWidgetState createState() =>
      _CompartimentoWidgetState(compartimento);
}

class _CompartimentoWidgetState extends State<CompartimentoWidget> {
  final TextEditingController _cCapacidade = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Compartimento compartimento;
  _CompartimentoWidgetState(this.compartimento) {
    compartimento.addListener(() {
      setState(() {
        print('Compartiemnto alterado');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        child: Card(
          elevation: 10,
          shadowColor: Colors.black,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(compartimento.id),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 10),
                      hintText: 'Cap. em litros',
                      hintStyle: TextStyle(fontSize: 10),
                    ),
                    controller: _cCapacidade,
                    onChanged: (_) => compartimento.capacidade =
                        int.tryParse(_cCapacidade.text) ?? 0,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: validaCapacidade,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(children: [
                      Text('Setas:'),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text('${compartimento.setas}'),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 25,
                            child: TextButton(
                                onPressed: () =>
                                    {gerSetas(compartimento.setas + 1)},
                                child: Icon(Icons.add)),
                          ),
                          SizedBox(
                            width: 25,
                            child: TextButton(
                                onPressed: () =>
                                    {gerSetas(compartimento.setas - 1)},
                                child: Icon(Icons.remove)),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  String? validaCapacidade(String? value) {
    if (value == null || value.isEmpty) return 'Informe a capacidade';
    final capacidade = int.tryParse(value);
    if (capacidade == null) return 'Capacidade inválida';
    if (capacidade % 10 != 0) return 'Somente múltiplos de 10';
    return null;
  }

  // String? validaSeta(String? value) {
  //   if (value == null || value.isEmpty) return 'Informe a capacidade';
  //   final capacidade = int.tryParse(value);
  //   if (capacidade == null) return 'Capacidade inválida';
  //   if (capacidade >= compartimento.capacidade)
  //     return 'Deve ser menor que ${compartimento.capacidade}L';
  //   if (capacidade % 10 != 0) return 'Somente múltiplos de 10';
  //   return null;
  // }

  gerSetas(int value) {
    if (value < 0) return;
    if (value > 10) return;
    setState(() {
      compartimento.setas = value;
    });
  }
}
