import 'package:agendamento_vtr/app/modules/tanque/models/compartimento.dart';
import 'package:flutter/material.dart';

class CompartimentoWidget extends StatefulWidget {
  final Compartimento compartimento;
  const CompartimentoWidget({Key? key, required this.compartimento})
      : super(key: key);

  @override
  _CompartimentoWidgetState createState() => _CompartimentoWidgetState();
}

class _CompartimentoWidgetState extends State<CompartimentoWidget> {
  final TextEditingController _cCapacidade = TextEditingController();
  final TextEditingController _cSeta = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        child: Card(
          elevation: 10,
          shadowColor: Colors.black,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: widget.compartimento.id,
                    hintText: 'Em litros',
                    hintStyle: TextStyle(fontSize: 10),
                  ),
                  controller: _cCapacidade,
                  onChanged: (_) => widget.compartimento.capacidade =
                      int.parse(_cCapacidade.text),
                  validator: validaCapacidade,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                      onPressed: () => showDialog(
                          barrierDismissible: true,
                          barrierColor: Color.fromRGBO(0, 0, 0, .5),
                          useSafeArea: true,
                          context: context,
                          builder: (_) => SimpleDialog(
                                elevation: 12,
                                title: Text('Dispositivo de referência'),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          labelText:
                                              'L${widget.compartimento.setas.length + 1}',
                                          hintStyle: TextStyle(fontSize: 10),
                                          hintText: 'Em litros'),
                                      controller: _cSeta,
                                      validator: validaCapacidade,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ElevatedButton(
                                      child: Text('Inserir'),
                                      onPressed: () => {
                                        if (_formKey.currentState!.validate())
                                          {
                                            setState(() {
                                              widget.compartimento.setas
                                                  .add(int.parse(_cSeta.text));
                                            }),
                                            Navigator.of(context).pop()
                                          }
                                      },
                                    ),
                                  )
                                ],
                              )),
                      icon: Icon(Icons.add),
                      label: Text('Seta')),
                ),
                Expanded(
                    child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.compartimento.setas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                        'L${index + 1}: ${widget.compartimento.setas[index]}');
                  },
                )),
              ],
            ),
          ),
        ));
  }

  String? validaCapacidade(String? value) {
    if (value == null || value.isEmpty) return 'Informe a capacidade';
    final capacidade = int.tryParse(value);
    if (capacidade == null) return 'Capacidade inválida';
    if (capacidade % 10 != 0) return 'Capacidade deve ser múltipla de 10';
    return null;
  }
}
