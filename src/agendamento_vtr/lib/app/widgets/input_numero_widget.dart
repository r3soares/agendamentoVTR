import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputNumeroWidget extends StatefulWidget {
  final int numeroPrevio;
  final String titulo;
  //Termo buscado e Resultado
  final Function(int) callback;
  InputNumeroWidget(
      {this.numeroPrevio = 0,
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
    _cNumero.text =
        widget.numeroPrevio == 0 ? '' : widget.numeroPrevio.toString();
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
          validator: validaNumero,
        ));
  }

  String? validaNumero(String? num) {
    if (num == null || num.isEmpty) return 'Insira um número válido';
    if (int.tryParse(num) == null) return 'Insira um número válido';
    return null;
  }

  void notificaListeners() {
    if (!focusNode.hasFocus)
      widget.callback(int.tryParse(_cNumero.text) ?? 0);
    else {
      _cNumero.selection =
          TextSelection(baseOffset: 0, extentOffset: _cNumero.text.length);
    }
  }
}