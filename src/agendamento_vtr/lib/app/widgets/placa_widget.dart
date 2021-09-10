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
  bool validou = false;

  @override
  void initState() {
    super.initState();
    _cPlaca.text = widget.placaPrevia;
    focusNode.addListener(notificaListeners);
  }

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.all(8),
        width: larguraTotal * .2,
        child: TextFormField(
          textCapitalization: TextCapitalization.characters,
          focusNode: focusNode,
          autofocus: true,
          decoration: InputDecoration(
            icon: Icon(Icons.drive_eta),
            hintText: 'Somente letras e números',
            hintStyle: TextStyle(fontSize: 10),
            labelText: widget.titulo,
          ),
          keyboardType: TextInputType.text,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[0-9A-Za-z]')),
          ],
          onChanged: (value) {
            _cPlaca.value = TextEditingValue(
                text: value.toUpperCase(), selection: _cPlaca.selection);
          },
          controller: _cPlaca,
          validator: validaPlaca,
        ));
  }

  String? validaPlaca(String? value) {
    validou = false;
    if (value == null || value.isEmpty) return 'Informe a placa';
    if (value.length != 7) return 'Placa inválida';
    RegExp regex = RegExp('[A-Z]{3}[0-9][0-9A-Z][0-9]{2}');
    if (!regex.hasMatch(value)) return 'Placa inválida';
    validou = true;
    return null;
  }

  void notificaListeners() {
    if (!focusNode.hasFocus || validou)
      widget.callback(_cPlaca.text, validou);
    else {
      _cPlaca.selection =
          TextSelection(baseOffset: 0, extentOffset: _cPlaca.text.length);
    }
  }
}
