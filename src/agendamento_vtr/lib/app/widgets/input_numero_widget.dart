import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputNumeroWidget extends StatefulWidget {
  final String numeroPrevio;
  final String titulo;
  //Termo buscado e Resultado
  final Function(String, bool) callback;
  InputNumeroWidget(
      {this.numeroPrevio = '',
      this.titulo = 'Número Inmetro',
      required this.callback});

  @override
  _InputNumeroWidgetWidgetState createState() =>
      _InputNumeroWidgetWidgetState();
}

class _InputNumeroWidgetWidgetState extends State<InputNumeroWidget> {
  final TextEditingController _cNumero = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cNumero.text = widget.numeroPrevio;
    focusNode.addListener(notificaListeners);
  }

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.all(8),
        width: larguraTotal * .2,
        child: TextFormField(
          autofocus: true,
          focusNode: focusNode,
          decoration: InputDecoration(
            //icon: Image.asset('assets/images/inmetro.png'),
            icon: Icon(Icons.arrow_right),
            hintText: 'Somente números',
            hintStyle: TextStyle(fontSize: 10),
            labelText: widget.titulo,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          controller: _cNumero,
        ));
  }

  void notificaListeners() {
    widget.callback(_cNumero.text, _cNumero.text.isNotEmpty);
  }
}
