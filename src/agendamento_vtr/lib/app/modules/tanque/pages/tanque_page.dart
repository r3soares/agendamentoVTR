import 'package:agendamento_vtr/app/modules/tanque/widgets/compartimento_form.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_dialog_widgets/doc_widget.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_dialog_widgets/tanque_zero_widget.dart';
import 'package:agendamento_vtr/app/widgets/input_numero_widget.dart';
import 'package:agendamento_vtr/app/widgets/placa_widget.dart';
import 'package:flutter/material.dart';

class TanquePage extends StatefulWidget {
  const TanquePage({Key? key}) : super(key: key);

  @override
  _TanquePageState createState() => _TanquePageState();
}

class _TanquePageState extends State<TanquePage> {
  final _formKey = GlobalKey<FormState>();
  final Widget placaWidget = PlacaWidget(callback: (_, valido) => null);
  final Widget inmetroWidget = InputNumeroWidget(callback: (_, valido) => null);
  final Widget docWidget = DocWidget(callback: (_, valido) => null);
  final Widget tanqueZeroWidget = TanqueZeroWidget(callback: (value) => null);
  final Widget compartimentoForm = CompartimentoForm(callback: (value) => null);

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Tanque'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: larguraTotal / 4),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              width: larguraTotal * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _titulo(),
                  _placaWidget(),
                  _numInmetroWidget(),
                  _docWidget(),
                  _tanqueZeroWidget(),
                  _compartimentoForm(),
                  Row(
                    children: [
                      //exibeBotoes()
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titulo() {
    return Container(
        padding: EdgeInsets.all(8),
        child: Text(
          "Tanque",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget _placaWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: placaWidget,
    );
  }

  Widget _numInmetroWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: inmetroWidget,
    );
  }

  Widget _docWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: docWidget,
    );
  }

  Widget _tanqueZeroWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: tanqueZeroWidget,
    );
  }

  Widget _compartimentoForm() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: compartimentoForm,
    );
  }

  bool verificaDadosPreenchidos() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }
}
