import 'package:agendamento_vtr/app/modules/tanque/models/compartimento.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/pages/pesquisa_dialog.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/pesquisa_empresas_widget.dart';
import 'package:agendamento_vtr/app/repository.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/compartimento_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../models/arquivo.dart';

class TanqueDialog extends StatefulWidget {
  const TanqueDialog({Key? key}) : super(key: key);

  @override
  _TanqueDialogState createState() => _TanqueDialogState();
}

class _TanqueDialogState extends State<TanqueDialog> {
  final qtdCompartimentos = List.generate(10, (index) => 1 + index);
  final _formKey = GlobalKey<FormState>();
  Tanque tanque = Tanque();
  final repo = Modular.get<Repository>();
  List<Compartimento> compartimentos = [Compartimento('C1')];
  TextEditingController _cPlaca = TextEditingController();

  @override
  void initState() {
    super.initState();
    tanque.responsavelAgendamento = Modular.get<Empresa>().cnpj;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          vertical: size.height / 8, horizontal: size.width / 6),
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
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Dados do Tanque',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                'Agendado por',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text('Ricardo M B Soares'),
                            ),
                            Container(
                              child: TextButton(
                                child: Text('Alterar'),
                                onPressed: () => {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PesquisaDialog();
                                      })
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Tanque zero?',
                                style: TextStyle(fontSize: 18),
                              ),
                              Checkbox(
                                value: tanque.isZero,
                                onChanged: (value) =>
                                    setState(() => tanque.isZero = value),
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
                                tanque.doc?.nome ?? '',
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
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text('Compartimentos:'),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text('${compartimentos.length}'),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: TextButton(
                                      onPressed: () => {
                                            geraCompartimentos(
                                                compartimentos.length + 1)
                                          },
                                      child: Icon(Icons.add)),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: TextButton(
                                      onPressed: () => {
                                            geraCompartimentos(
                                                compartimentos.length - 1)
                                          },
                                      child: Icon(Icons.remove)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                          height: size.height * .25,
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: compartimentos.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(index);
                              return CompartimentoWidget(
                                  compartimento: compartimentos[index]);
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          child: Text('Inserir'),
                          onPressed: () => {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate())
                              {
                                _criaTanque(),
                                Navigator.of(context).pop(),
                              }
                          },
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
    if (value.length != 7) return 'Placa inválida';
    RegExp regex = RegExp('[A-Z]{3}[0-9][0-9A-Z][0-9]{2}');
    if (!regex.hasMatch(value)) return 'Placa inválida';
    return null;
  }

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);

    if (result != null) {
      setState(() {
        tanque.doc = Arquivo(
          result.files.single.bytes!,
          result.files.single.name,
          result.files.single.extension!,
        );
      });
    } else {
      // User canceled the picker
    }
  }

  void geraCompartimentos(int value) {
    if (value > 10) return;
    if (value == 0) return;
    if (value == compartimentos.length) return;
    setState(() {
      compartimentos =
          List.generate(value, (index) => Compartimento('C${index + 1}'));
    });
  }

  void _criaTanque() {
    tanque.placa = _cPlaca.text;
    tanque.compartimentos = compartimentos;
    tanque.dataRegistro = DateTime.now();
    final formulario = Modular.get<Empresa>();
    formulario.addTanque(tanque.placa);
    tanque.proprietario = formulario.cnpj;

    repo.addTanque(tanque);
  }
}
