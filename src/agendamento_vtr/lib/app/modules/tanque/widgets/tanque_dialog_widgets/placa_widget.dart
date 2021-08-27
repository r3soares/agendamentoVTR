import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:flutter/material.dart';

class PlacaWidget extends StatefulWidget {
  final Tanque tanque;
  const PlacaWidget(this.tanque);

  @override
  _PlacaWidgetState createState() => _PlacaWidgetState();
}

class _PlacaWidgetState extends State<PlacaWidget> {
  TextEditingController _cPlaca = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              helperText: 'Somente letras e números',
              icon: Icon(Icons.drive_eta),
              labelText: 'Placa',
            ),
            onSaved: (String? value) {
              widget.tanque.placa = _cPlaca.text;
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            onChanged: (value) {
              _cPlaca.value = TextEditingValue(
                  text: value.toUpperCase(), selection: _cPlaca.selection);
            },
            controller: _cPlaca,
            validator: validaPlaca));
  }

  String? validaPlaca(String? value) {
    if (value == null || value.isEmpty) return 'Informe a placa';
    if (value.length != 7) return 'Placa inválida';
    RegExp regex = RegExp('[A-Z]{3}[0-9][0-9A-Z][0-9]{2}');
    if (!regex.hasMatch(value)) return 'Placa inválida';
    return null;
  }
}
