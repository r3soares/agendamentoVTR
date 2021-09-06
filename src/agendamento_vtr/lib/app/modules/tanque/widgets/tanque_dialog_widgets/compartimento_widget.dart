import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompartimentoWidget extends StatefulWidget {
  final Compartimento compartimento;
  final Function(Compartimento) callback;
  const CompartimentoWidget(
      {Key? key, required this.compartimento, required this.callback})
      : super(key: key);

  @override
  _CompartimentoWidgetState createState() => _CompartimentoWidgetState();
}

class _CompartimentoWidgetState extends State<CompartimentoWidget> {
  final TextEditingController _cCapacidade = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  @override
  initState() {
    widget.compartimento.addListener(() {
      widget.callback(widget.compartimento);
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _cCapacidade.selection = TextSelection(
            baseOffset: 0, extentOffset: _cCapacidade.text.length);
      }
    });
    _cCapacidade.text = widget.compartimento.capacidade.toString();
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
                  Text(widget.compartimento.id),
                  TextFormField(
                    focusNode: focusNode,
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 10),
                      hintText: 'Cap. em litros',
                      hintStyle: TextStyle(fontSize: 10),
                    ),
                    controller: _cCapacidade,
                    onChanged: (_) => widget.compartimento.capacidade =
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
                        child: Text('${widget.compartimento.setas}'),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 25,
                            child: TextButton(
                                onPressed: () =>
                                    {gerSetas(widget.compartimento.setas + 1)},
                                child: Icon(Icons.add)),
                          ),
                          SizedBox(
                            width: 25,
                            child: TextButton(
                                onPressed: () =>
                                    {gerSetas(widget.compartimento.setas - 1)},
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
      widget.compartimento.setas = value;
    });
  }
}
