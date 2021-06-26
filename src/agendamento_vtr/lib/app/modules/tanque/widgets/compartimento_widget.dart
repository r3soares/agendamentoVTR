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
  final TextEditingController _cSeta = TextEditingController();
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
    print('Desenhou Compartimento Widget');
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
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: compartimento.id,
                      hintText: 'Em litros',
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
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                        onPressed: compartimento.capacidade % 10 == 0
                            ? () => showDialog(
                                barrierDismissible: true,
                                barrierColor: Color.fromRGBO(0, 0, 0, .5),
                                useSafeArea: true,
                                context: context,
                                builder: (_) => SimpleDialog(
                                      elevation: 12,
                                      title: Text('Dispositivo de referência'),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 8),
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            decoration: InputDecoration(
                                                labelText:
                                                    'L${widget.compartimento.setas.length + 1}',
                                                hintStyle:
                                                    TextStyle(fontSize: 10),
                                                hintText: 'Em litros'),
                                            controller: _cSeta,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            validator: validaSeta,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: ElevatedButton(
                                            child: Text('Inserir'),
                                            onPressed: () => {
                                              if (_formKey.currentState!
                                                  .validate())
                                                {
                                                  setState(() {
                                                    compartimento.setas.add(
                                                        int.parse(_cSeta.text));
                                                  }),
                                                  Navigator.of(context).pop()
                                                }
                                            },
                                          ),
                                        )
                                      ],
                                    ))
                            : null,
                        icon: Icon(Icons.add),
                        label: Text('Seta')),
                  ),
                  Expanded(
                      child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: compartimento.setas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                          'L${index + 1}: ${compartimento.setas[index]}');
                    },
                  )),
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

  String? validaSeta(String? value) {
    if (value == null || value.isEmpty) return 'Informe a capacidade';
    final capacidade = int.tryParse(value);
    if (capacidade == null) return 'Capacidade inválida';
    if (capacidade >= compartimento.capacidade)
      return 'Deve ser menor que ${compartimento.capacidade}L';
    if (capacidade % 10 != 0) return 'Somente múltiplos de 10';
    return null;
  }
}
