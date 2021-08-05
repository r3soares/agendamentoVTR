import 'package:agendamento_vtr/app/modules/tanque/models/compartimento.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_dialog_widgets/crlv_nf_widget.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_dialog_widgets/placa_widget.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_dialog_widgets/responsavel_widget.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_dialog_widgets/tanque_zero_widget.dart';
import 'package:agendamento_vtr/app/repository.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_dialog_widgets/compartimento_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
                      ResponsavelWidget(Modular.get<Empresa>()),
                      TanqueZeroWidget(tanque),
                      PlacaWidget(tanque),
                      CrlvNfWidget(tanque),
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
    tanque.compartimentos = compartimentos;
    tanque.dataRegistro = DateTime.now();
    final proprietario = Modular.get<Empresa>();
    proprietario.addTanque(tanque.placa);
    tanque.proprietario = proprietario.cnpj;

    repo.addTanque(tanque);
  }
}
