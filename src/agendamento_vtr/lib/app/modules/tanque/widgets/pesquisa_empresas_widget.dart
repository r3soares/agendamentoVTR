import 'package:agendamento_vtr/app/modules/util/cnpj.dart';
import 'package:agendamento_vtr/app/modules/util/cpf.dart';
import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PesquisaEmpresaWidget extends StatefulWidget {
  const PesquisaEmpresaWidget();

  @override
  _PesquisaEmpresaWidgetState createState() => _PesquisaEmpresaWidgetState();
}

class _PesquisaEmpresaWidgetState extends State<PesquisaEmpresaWidget> {
  final TextEditingController _cPesquisa = TextEditingController();
  var _empresaResultadoPesquisa;
  final controller = Modular.get<PesquisaController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          _empresaResultadoPesquisa = controller.resultado;
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
            validator: buscaTermo,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Pesquisar',
              hintText: 'Informe o CPF ou CNPJ',
              suffixIcon: IconButton(
                onPressed: limpaTermo,
                icon: Icon(Icons.clear),
              ),
            ),
          ),
          trailing: controller.status == 2
              ? TextButton(onPressed: () => {}, child: Text('Novo'))
              : SizedBox.shrink(),
        ),
      ),
    );
  }

  String? validaCNPJCPF(String? value) {
    if (value == null || value.isEmpty) return 'Informe o CNPJ ou CPF';
    if (value.length != 14 && value.length != 11) return 'CNPJ ou CPF inválido';
    if (!CPF.isValid(value) && !CNPJ.isValid(value))
      return 'CNPJ ou CPF inválido';
    return null;
  }

  String? buscaTermo(String? termo) {
    if (termo == null || termo.isEmpty) return null;
    final resultado = validaCNPJCPF(termo);
    if (resultado != null) return resultado;
    if (!controller.pesquisaEmpresa(termo)) {
      return 'Não localizado';
    }
  }

  void limpaTermo() {
    _cPesquisa.clear();
    controller.resetPesquisa();
  }
}
