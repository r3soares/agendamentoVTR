import 'package:agendamento_vtr/app/modules/agendamento/pages/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PesquisaWidget extends StatefulWidget {
  const PesquisaWidget({Key? key}) : super(key: key);

  @override
  _PesquisaWidgetState createState() => _PesquisaWidgetState();
}

class _PesquisaWidgetState extends State<PesquisaWidget> {
  final TextEditingController _cPesquisa = TextEditingController();
  var _tanqueResultadoPesquisa;
  final controller = Modular.get<PesquisaController>();
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          _tanqueResultadoPesquisa = controller.resultado;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        width: size.width * .20,
        child: ListTile(
          title: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _cPesquisa,
            textCapitalization: TextCapitalization.characters,
            onChanged: (value) {
              _cPesquisa.value = TextEditingValue(text: value.toUpperCase(), selection: _cPesquisa.selection);
            },
            maxLength: 7,
            validator: buscaTermo,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Pesquisar',
              hintText: 'Informe a placa',
              suffixIcon: IconButton(
                onPressed: limpaTermo,
                icon: Icon(Icons.clear),
              ),
            ),
          ),
          trailing: controller.status == 1
              ? ElevatedButton(
                  onPressed: () => {
                        showDialog(
                            barrierDismissible: true,
                            barrierColor: Color.fromRGBO(0, 0, 0, .5),
                            useSafeArea: true,
                            context: context,
                            builder: (_) => VisualizaTanqueDialog(_tanqueResultadoPesquisa)),
                      },
                  child: Text('${_tanqueResultadoPesquisa.placa}'))
              : SizedBox.shrink(),
        ),
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

  String? buscaTermo(String? termo) {
    if (termo == null || termo.isEmpty || termo.length < 7) return null;
    controller.pesquisaTanque(termo);
    _cPesquisa.clear();
  }

  void limpaTermo() {
    _cPesquisa.clear();
    controller.resetPesquisa();
  }
}
