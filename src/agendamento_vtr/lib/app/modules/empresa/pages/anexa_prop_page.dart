import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:agendamento_vtr/app/modules/empresa/stores/empresa_store.dart';
import 'package:agendamento_vtr/app/widgets/base_widgets.dart';
import 'package:agendamento_vtr/app/widgets/input_numero_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AnexaPropPage extends BaseWidgets {
  final Empresa empresa;
  final largura = .5;
  AnexaPropPage({required this.empresa});

  @override
  _AnexaPropPageState createState() => _AnexaPropPageState();
}

class _AnexaPropPageState extends ModularState<AnexaPropPage, EmpresaStore> {
  late Proprietario proprietario;
  late Widget inmetroWidget;
  late Widget codMunWidget;

  @override
  void initState() {
    super.initState();
    proprietario = widget.empresa.proprietario ?? Proprietario();
    inmetroWidget = InputNumeroWidget(
      titulo: 'Número Inmetro',
      input: TipoInput.Numeros,
      callback: (codInmetro) => proprietario.cod = int.tryParse(codInmetro) ?? 0,
      campoPrevio: '${proprietario.cod}',
    );
    codMunWidget = InputNumeroWidget(
        titulo: 'Código do Município',
        input: TipoInput.Numeros,
        callback: (codMun) => proprietario.codMun = int.tryParse(codMun) ?? 0,
        campoPrevio: '${proprietario.codMun}');
    _configStream();
  }

  void _configStream() {
    store.sEmpresa.observer(
      onState: (e) => {
        _exibeMsg('Empresa salva com sucesso.'),
        Modular.to.pop(),
      },
      onLoading: loading,
      onError: _showErro,
    );
  }

  loading(bool isLoading) {
    widget.loading(isLoading, context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.empresa.cnpjCpf}'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 50),
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: size.height * .5,
            width: size.width * .5,
            child: Card(
              shadowColor: Colors.black,
              elevation: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  titulo(),
                  _inmetroWidget(),
                  _codMunWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [widget.btnsalvar(onPressed: _salvaEmpresa), widget.btnVoltar()],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget titulo() {
    return Container(
        padding: EdgeInsets.all(8),
        child: Text(
          "Dados do Proprietário",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget _inmetroWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: inmetroWidget,
      ),
    );
  }

  Widget _codMunWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: codMunWidget,
      ),
    );
  }

  bool verificaDadosPreenchidos() {
    if (proprietario.cod <= 0 || proprietario.codMun == 0) return false;
    return true;
  }

  _salvaEmpresa() {
    if (!verificaDadosPreenchidos()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe os campos corretamente')));
      return;
    }
    widget.empresa.proprietario = proprietario;
    store.salva(widget.empresa);
    print('Salvando proprietario: ${proprietario.cod}');
  }

  _exibeMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  _showErro(Falha erro) {
    if (!verificaDadosPreenchidos()) return;
    switch (erro.runtimeType) {
      case ErroConexao:
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Não foi possível salvar os dados. Erro de conexão'),
            backgroundColor: Colors.red[900],
          ));
          break;
        }
      case Falha:
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Não foi possível salvar os dados. ${erro.msg}'), backgroundColor: Colors.red[900]));
          break;
        }
    }
  }
}
