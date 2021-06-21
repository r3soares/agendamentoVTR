import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TanqueDialogWidget extends StatefulWidget {
  final String title;

  TanqueDialogWidget({Key? key, this.title = "TanqueDialogWidget"})
      : super(key: key);

  @override
  _TanqueDialogWidgetState createState() => _TanqueDialogWidgetState();
}

class _TanqueDialogWidgetState extends State<TanqueDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  File? arquivo;
  String nome = '';

  final TextEditingController _cPlaca = TextEditingController();

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
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    onPressed: () => getFile(),
                    icon: Icon(Icons.file_upload),
                    label: Text('CRLV ou NF'),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  child: Text(nome),
                )
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

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);

    if (result != null) {
      arquivo = File.fromRawPath(result.files.single.bytes!);
      setState(() {
        nome = result.files.single.name;
      });
    } else {
      // User canceled the picker
    }
  }
}
