import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/compartimento_form.dart';
import 'package:flutter/material.dart';

class TanqueFormWidget extends StatefulWidget {
  final Tanque tanque;

  TanqueFormWidget(this.tanque) {}

  @override
  State<TanqueFormWidget> createState() => _TanqueFormWidgetState();
}

class _TanqueFormWidgetState extends State<TanqueFormWidget> {
  late CompartimentoForm formCompartimento;
  late TextEditingController _cPlaca;
  final TextEditingController _cInmetro = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formCompartimento = CompartimentoForm(
        compartimentosPrevio: widget.tanque.compartimentos,
        callback: atualizaCompartimento);
    _cPlaca = TextEditingController(text: widget.tanque.placa);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Row(
          children: [
            Container(
              width: 200,
              margin: EdgeInsets.all(12),
              child: TextFormField(
                controller: _cPlaca,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Placa',
                ),
              ),
            ),
            Container(
              width: 200,
              margin: EdgeInsets.all(12),
              child: TextFormField(
                controller: _cInmetro,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Inmetro',
                ),
              ),
            ),
          ],
        ),
        formCompartimento,
      ]),
    );
  }

  atualizaCompartimento(List<Compartimento> compartimentos) {
    widget.tanque.compartimentos.clear();
    widget.tanque.compartimentos.addAll(compartimentos);
  }
}
