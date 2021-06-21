import 'package:flutter/material.dart';

class TanqueDialogWidget extends StatelessWidget {
  final String title;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cPlaca = TextEditingController();
  TanqueDialogWidget({Key? key, this.title = "TanqueDialogWidget"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          vertical: size.height / 4, horizontal: size.width / 4),
      elevation: 2,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * .10),
          color: Colors.white,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          helperText: 'Somente letras e números',
                          icon: Icon(Icons.drive_eta),
                          labelText: 'Placa',
                        ),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        onChanged: (value) {
                          _cPlaca.value = TextEditingValue(
                              text: value.toUpperCase(),
                              selection: _cPlaca.selection);
                        },
                        controller: _cPlaca,
                        validator: validaPlaca)),
              ],
            ),
          )),
    );
  }

  String? validaPlaca(String? value) {
    if (value == null || value.isEmpty) return 'Informe a placa';
    RegExp regex = RegExp('[A-Z]{3}[0-9][0-9A-Z][0-9]{2}');
    if (!regex.hasMatch(value)) return 'Placa inválida';
    return null;
  }
}
