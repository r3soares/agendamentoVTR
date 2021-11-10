import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputNumeroWidget extends StatefulWidget {
  final String campoPrevio;
  final String titulo;
  final TipoInput input;
  //Termo buscado e Resultado
  final Function(String) callback;
  const InputNumeroWidget({this.campoPrevio = '', this.titulo = '', required this.input, required this.callback});

  @override
  _InputNumeroWidgetWidgetState createState() => _InputNumeroWidgetWidgetState();
}

class _InputNumeroWidgetWidgetState extends State<InputNumeroWidget> {
  final TextEditingController _cCampo = TextEditingController();
  final focusNode = FocusNode();

  late List<TextInputFormatter> inputFormater;
  late String? Function(String?) validaInput;
  late String dicaTexto;

  @override
  void initState() {
    super.initState();
    _setValidators();
    _cCampo.text = widget.campoPrevio;
    focusNode.addListener(notificaListeners);
  }

  void _setValidators() {
    switch (widget.input) {
      case (TipoInput.Letras):
        {
          validaInput = validaLetras;
          inputFormater = <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
          ];
          dicaTexto = 'Somente letras';
          break;
        }
      case (TipoInput.Numeros):
        {
          validaInput = validaNumero;
          inputFormater = <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ];
          dicaTexto = 'Somente números';
          break;
        }
      case (TipoInput.NumLetras):
        {
          validaInput = validaNumLetras;
          inputFormater = <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
          ];
          dicaTexto = 'Somente letras e números';
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      decoration: InputDecoration(
        //icon: Image.asset('assets/images/inmetro.png'),
        icon: Icon(Icons.looks_one),
        hintText: dicaTexto,
        hintStyle: TextStyle(fontSize: 10),
        labelText: widget.titulo,
      ),
      inputFormatters: inputFormater,
      controller: _cCampo,
      validator: validaInput,
    );
  }

  String? validaNumero(String? num) {
    if (num == null || num.isEmpty) return 'Insira um número válido';
    var n = int.tryParse(num);
    if (n == null || n <= 0) return 'Insira um número válido';
    return null;
  }

  String? validaLetras(String? num) {
    if (num == null || num.isEmpty) return 'Insira um nome válido';
    return null;
  }

  String? validaNumLetras(String? num) {
    if (num == null || num.isEmpty) return 'Insira um valor válido';
    return null;
  }

  void notificaListeners() {
    if (!focusNode.hasFocus)
      widget.callback(_cCampo.text);
    else {
      _cCampo.selection = TextSelection(baseOffset: 0, extentOffset: _cCampo.text.length);
    }
  }
}

enum TipoInput {
  Numeros,
  Letras,
  NumLetras,
}
