import 'package:agendamento_vtr/app/domain/validacoes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TelefoneWidget extends StatefulWidget {
  const TelefoneWidget({Key? key}) : super(key: key);

  @override
  _TelefoneWidgetState createState() => _TelefoneWidgetState();
}

class _TelefoneWidgetState extends State<TelefoneWidget> {
  final FocusNode _focusNode = FocusNode();
  final Validacoes _valida = Validacoes();
  final TextEditingController _controller = TextEditingController();
  final MaskTextInputFormatter _maskInicial =
      new MaskTextInputFormatter(mask: '###########', filter: {"#": RegExp(r'[0-9]')});
  final String _maskCelular = '(##) # ####-####';
  final String _maskTelefone = '(##) ####-####';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _controller.value = _maskInicial.getUnmaskedText().length > 10
              ? _maskInicial.updateMask(mask: _maskCelular)
              : _maskInicial.updateMask(mask: _maskTelefone);
        });
      } else {
        _controller.value = _maskInicial.updateMask(mask: '(##) #########');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        focusNode: _focusNode,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            icon: Icon(Icons.phone), hintStyle: TextStyle(fontSize: 10), labelText: 'Telefone com DDD'),
        validator: validateTelefone,
        controller: _controller,
        inputFormatters: [_maskInicial]);
  }

  String? validateTelefone(String? value) {
    if (value == null || value.isEmpty) return null;
    return _valida.validaTelefone(_maskInicial.getUnmaskedText()) ? null : 'Telefone inválido';
  }
}
