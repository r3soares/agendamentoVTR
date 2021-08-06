import 'package:agendamento_vtr/app/modules/empresa/controllers/empresa_controller.dart';
import 'package:agendamento_vtr/app/modules/empresa/widgets/proprietario_page_widgets/cnpj_widget.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CadastroPage extends StatefulWidget {
  final largura = .5;
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final controller = Modular.get<EmpresaController>();

  final TextEditingController _cRazaSocialProp = TextEditingController();

  final TextEditingController _cTelefone = TextEditingController();

  final TextEditingController _cEmail = TextEditingController();

  _CadastroPageState() {
    controller.empresa = Empresa();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      atualizaDadosProprietario();
    });
  }

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Proprietário'),
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
                  titulo(),
                  CnpjWidget(),
                  razaoSocial(),
                  telefone(),
                  email(),
                  btnSalvar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget titulo() {
    return Container(
        child: Text(
      "Dados do Proprietário",
      style: TextStyle(fontSize: 20),
    ));
  }

  Widget cpfCnpj() {
    return CnpjWidget();
  }

  Widget razaoSocial() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            labelText: 'Razão Social ou Nome do Proprietário',
          ),
          controller: _cRazaSocialProp,
          validator: (String? value) {
            return (value != null && value.length > 0)
                ? null
                : 'Informe um nome';
          },
        ));
  }

  Widget telefone() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            icon: Icon(Icons.phone),
            hintStyle: TextStyle(fontSize: 10),
            labelText: 'Telefone para contato, se houver',
          ),
          controller: _cTelefone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
        ));
  }

  Widget email() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          hintStyle: TextStyle(fontSize: 10),
          labelText: 'E-mail para contato',
        ),
        keyboardType: TextInputType.emailAddress,
        controller: _cEmail,
        validator: validateEmail,
        onSaved: (String? value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
      ),
    );
  }

  Widget btnSalvar() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Salvar'),
              onPressed: () => _salvaProprietario(context),
            ),
          ),
        ],
      ),
    );
  }

  void atualizaDadosProprietario() {
    if (!mounted) return;
    setState(() {
      _cRazaSocialProp.text = controller.empresa.razaoSocial;
      _cTelefone.text = controller.empresa.telefone ?? '';
      _cEmail.text = controller.empresa.email;
    });
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe um e-mail';
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) return 'E-mail inválido';
    return null;
  }

  bool verificaDadosPreenchidos() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }

  void _insereDadosNoProprietario() {
    //controller.proprietario.cnpj = _cCnpjCpf.text;
    controller.empresa.email = _cEmail.text;
    controller.empresa.telefone = _cTelefone.text;
    controller.empresa.razaoSocial = _cRazaSocialProp.text;
  }

  bool _salvaProprietario(context) {
    if (!verificaDadosPreenchidos()) return false;
    _insereDadosNoProprietario();
    controller.salvaEmpresa();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Proprietário Salvo')));
    return true;
  }
}
