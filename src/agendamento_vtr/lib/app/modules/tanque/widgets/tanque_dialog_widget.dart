import 'dart:io';

import 'package:agendamento_vtr/app/modules/tanque/widgets/compartimento_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TanqueDialogWidget extends StatefulWidget {
  final String title;
  final compartimentos = List.generate(10, (index) => 1 + index);

  TanqueDialogWidget({Key? key, this.title = "TanqueDialogWidget"})
      : super(key: key);

  @override
  _TanqueDialogWidgetState createState() => _TanqueDialogWidgetState();
}

class _TanqueDialogWidgetState extends State<TanqueDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  File? arquivo;
  String? extensao;
  bool? isChecked = false;
  String nome = '';
  String dropdownValue = '1';
  List<CompartimentoWidget> compartimentos = List.empty();

  final TextEditingController _cPlaca = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          vertical: size.height / 5, horizontal: size.width / 6),
      elevation: 2,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * .10),
                color: Colors.white,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Tanque zero?',
                                style: TextStyle(fontSize: 18),
                              ),
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) =>
                                    setState(() => isChecked = value),
                              )
                            ],
                          )),
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
                        child: Row(children: [
                          ElevatedButton.icon(
                            onPressed: () => getFile(),
                            icon: Icon(Icons.file_upload),
                            label: Text('CRLV ou NF'),
                          ),
                          Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                nome,
                                style: TextStyle(fontSize: 10),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text('Compartimentos:'),
                                ),
                                Expanded(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: dropdownValue,
                                    icon:
                                        const Icon(Icons.arrow_drop_down_sharp),
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: widget.compartimentos
                                        .map<DropdownMenuItem<String>>(
                                            (int value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ])),
                      Container(
                          height: size.height * .4,
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: int.parse(dropdownValue),
                            itemBuilder: (BuildContext context, int index) {
                              return CompartimentoWidget(
                                  title: 'C${index + 1}');
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          child: Text('Inserir'),
                          onPressed: () => {},
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ),
        ],
      ),
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
      extensao = result.files.single.extension;
      setState(() {
        nome = result.files.single.name;
      });
    } else {
      // User canceled the picker
    }
  }

  void geraCompartimentos(int value) {
    if (value == compartimentos.length) return;
    compartimentos = List.generate(
        value, (index) => CompartimentoWidget(title: 'C${index + 1}'));
  }
}
