import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlacaWidget extends StatefulWidget {
  final String placaPrevia;
  final String titulo;
  //Termo buscado e Resultado
  final Function(String, bool) callback;
  PlacaWidget(
      {this.placaPrevia = '', this.titulo = 'Placa', required this.callback});

  @override
  _PlacaWidgetState createState() => _PlacaWidgetState();
}

class _PlacaWidgetState extends State<PlacaWidget> {
  final TextEditingController _cPlaca = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cPlaca.text = widget.placaPrevia;
    focusNode.addListener(notificaListeners);
  }

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
            padding: EdgeInsets.all(8),
            width: larguraTotal * .4,
            child: TextFormField(
              textCapitalization: TextCapitalization.characters,
              focusNode: focusNode,
              decoration: InputDecoration(
                icon: Icon(Icons.drive_eta),
                hintText: 'Somente letras e números',
                hintStyle: TextStyle(fontSize: 10),
                labelText: widget.titulo,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]')),
              ],
              onChanged: (value) {
                _cPlaca.value = TextEditingValue(
                    text: value.toUpperCase(), selection: _cPlaca.selection);
              },
              controller: _cPlaca,
              validator: validaPlaca,
            )),
      ],
    );
  }

  String? validaPlaca(String? value) {
    if (value == null || value.isEmpty) return 'Informe a placa';
    if (value.length != 7) return 'Placa inválida';
    RegExp regex = RegExp('[A-Z]{3}[0-9][0-9A-Z][0-9]{2}');
    if (!regex.hasMatch(value)) return 'Placa inválida';
    return null;
  }

  void notificaListeners() {
    widget.callback(_cPlaca.text, validaPlaca(_cPlaca.text) == null);
  }
}
