import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/empresa/stores/empresa_store.dart';
import 'package:agendamento_vtr/app/modules/tanque/stores/tanque_store.dart';
import 'package:agendamento_vtr/app/widgets/cnpj_widget.dart';
import 'package:agendamento_vtr/app/widgets/placa_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends ModularState<CadastroPage, TanqueStore> {
  final _formKey = GlobalKey<FormState>();
  final List<Tanque> tanques = List.empty(growable: true);
  final EmpresaStore storeEmpresa = EmpresaStore();
  Size? _size;
  String cnpjProprietario = '';
  late Disposer _disposer;
  late Disposer _disposerEmpresa;

  late Widget proprietarioWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF',
    callback: (cnpj, valido) => cnpjProprietario = valido ? cnpj : '',
  );
  late Widget placaWidget = PlacaWidget(
    titulo: 'Buscar placa',
    callback: _getTanque,
  );

  late OverlayEntry loadingOverlay = OverlayEntry(builder: (_) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black38,
      child: CircularProgressIndicator(),
    );
  });

  @override
  void initState() {
    super.initState();
    _configStream();
  }

  @override
  void dispose() {
    super.dispose();
    _disposer();
    _disposerEmpresa();
    storeEmpresa.destroy();
  }

  void _configStream() {
    _disposer = store.observer(
        onState: (ModelBase t) => {
              if (t.status == Status.ConsultaPlaca)
                {
                  _incluiTanque(t.model),
                }
              else if (t.status == Status.Salva)
                {}
            },
        onLoading: (isLoading) {
          if (store.isLoading) {
            Overlay.of(context)?.insert(loadingOverlay);
          } else {
            loadingOverlay.remove();
          }
        },
        onError: (error) {
          _showErro(context, error);
        });
    _disposerEmpresa = storeEmpresa.observer(
        onState: (e) => {
              if (e.status == Status.Consulta)
                {
                  for (var t in tanques)
                    {
                      t.proprietario = cnpjProprietario,
                      store.salva(t),
                      (e.model as Empresa).addTanque(t.placa),
                    },
                  _msgTemporaria('Dados salvos'),
                  Modular.to.pop(),
                }
            },
        onLoading: (isLoading) {
          if (store.isLoading) {
            Overlay.of(context)?.insert(loadingOverlay);
          } else {
            loadingOverlay.remove();
          }
        },
        onError: (error) {
          _showErro(context, error);
        });
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Veículo Tanque'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _size!.width / 4),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _camposPropResp(),
                _camposTanques(),
                _camposBotoes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _camposPropResp() {
    return Container(
      //width: larguraTotal * .4,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(4),
              child: titulo('Proprietário'),
            ),
            Column(
              children: [
                Form(
                  child: proprietarioWidget,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                ),
                //responsavelWidget,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _camposBotoes() {
    return Row(
      children: [
        btnSalvar(),

        //exibeBotoes()
      ],
    );
  }

  Widget _camposTanques() {
    return Container(
      //width: larguraTotal * .4,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(4),
              child: titulo('Tanques'),
            ),
            Column(
              children: [
                Row(
                  children: [
                    _placaWidget(),
                    btnTanque(),
                  ],
                ),
                _listaTanques(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget titulo(String titulo) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Text(
          titulo,
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget btnSalvar() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Text('Salvar'),
            onPressed: () => _salvaDados(),
          ),
        ),
      ),
    );
  }

  Widget btnTanque() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            child: Text('Novo Tanque'),
            onPressed: _goTanquePage,
          ),
        ),
      ),
    );
  }

  Widget _placaWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: placaWidget,
      ),
    );
  }

  Widget _listaTanques() {
    return SingleChildScrollView(
      child: Container(
          width: _size!.width * .5,
          height: 170,
          child: tanques.isEmpty
              ? SizedBox.shrink()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tanques.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _tanqueWidget(index);
                  },
                )),
    );
  }

  Widget _tanqueWidget(int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    child: Text(
                      tanques[index].placa.replaceRange(3, 3, '-'),
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => _goTanquePage(tExistente: tanques[index]),
                  )),
              Container(
                padding: const EdgeInsets.all(4),
                child: Text('${tanques[index].capacidadeTotal}L'),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                child: Text('${tanques[index].compartimentos.length}C ${_somaSetas(tanques[index])}SS'),
              ),
              Container(
                child: IconButton(
                  splashRadius: 10,
                  icon: Icon(
                    Icons.close,
                    color: Colors.red[900],
                  ),
                  onPressed: () => _removeTanque(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _somaSetas(Tanque t) {
    return t.compartimentos.fold(0, (previousValue, element) => previousValue + element.setas);
  }

  void _salvaDados() {
    if (!_validaForm()) {
      _msgTemporaria('Há campos inválidos');
      return;
    }
    _associaPropAosTanques();
  }

  void _associaPropAosTanques() {
    storeEmpresa.consulta(cnpjProprietario);
  }

  void _goTanquePage({Tanque? tExistente}) {
    if (!_validaForm()) {
      _msgTemporaria('Informe um CNPJ/CPF válido');
      return;
    }

    Modular.to.pushNamed('cadastroTanque', arguments: tExistente);
  }

  void _incluiTanque(Tanque t) {
    if (!tanques.contains(t)) {
      setState(() {
        tanques.add(t);
      });
    }
  }

  void _msgTemporaria(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool _validaForm() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }

  void _getTanque(String placa, bool valido) async {
    if (valido) {
      store.consultaPlaca(placa);
    }
  }

  void _removeTanque(int index) {
    setState(() {
      tanques.removeAt(index);
    });
  }

  _showErro(BuildContext ctx, Falha erro) {
    if (!_validaForm()) return;
    switch (erro.runtimeType) {
      case ErroConexao:
        {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text('Não foi possível salvar os dados. Erro de conexão'),
            backgroundColor: Colors.red[900],
          ));
          break;
        }
      case NaoEncontrado:
        {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Não localizado. ${erro.msg}')));
          break;
        }
      case Falha:
        {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text('Não foi possível salvar os dados. ${erro.msg}'), backgroundColor: Colors.red[900]));
          break;
        }
    }
  }
}
