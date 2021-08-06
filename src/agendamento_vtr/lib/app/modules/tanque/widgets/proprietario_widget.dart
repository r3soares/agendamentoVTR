import 'package:agendamento_vtr/app/message_controller.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/tanque/pages/tanque_dialog.dart';
import 'package:agendamento_vtr/app/repository.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_widget.dart';
import 'package:agendamento_vtr/app/modules/util/cnpj.dart';
import 'package:agendamento_vtr/app/modules/util/cpf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProprietarioWidget extends StatefulWidget {
  const ProprietarioWidget({Key? key}) : super(key: key);

  @override
  _ProprietarioWidgetState createState() => _ProprietarioWidgetState();
}

class _ProprietarioWidgetState extends State<ProprietarioWidget> {
  final _formKey = GlobalKey<FormState>();

  final proprietario = Empresa();

  final repo = Modular.get<Repository>();

  final TextEditingController _cRazaSocialProp = TextEditingController();

  final TextEditingController _cCnpjCpf = TextEditingController();

  final TextEditingController _cTelefone = TextEditingController();

  final TextEditingController _cEmail = TextEditingController();

  bool isSalvo = false;

  _ProprietarioWidgetState() {
    proprietario.addListener(() {
      setState(() {
        print("Tanque adicionado");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: larguraTotal / 4),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Text(
                "Dados do Solicitante",
                style: TextStyle(fontSize: 20),
              )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: !isSalvo,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.badge),
                      hintText: 'Somente números',
                      hintStyle: TextStyle(fontSize: 10),
                      labelText: 'CNPJ ou CPF do Proprietário',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    controller: _cCnpjCpf,
                    validator: validaCNPJCPF,
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: !isSalvo,
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
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: !isSalvo,
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
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  enabled: !isSalvo,
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isSalvo
                    ? ElevatedButton.icon(
                        onPressed: () => setState(() => isSalvo = false),
                        icon: Icon(Icons.edit),
                        label: Text('Alterar'))
                    : SizedBox.shrink(),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text('Salvar'),
                        onPressed: !isSalvo
                            ? () => {
                                  _salvaProprietario()
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Proprietário Salvo')))
                                      : null
                                }
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          onPressed: isSalvo
                              ? () => showDialog(
                                  barrierDismissible: false,
                                  barrierColor: Color.fromRGBO(0, 0, 0, .5),
                                  useSafeArea: true,
                                  context: context,
                                  builder: (_) => const TanqueDialog())
                              : null,
                          icon: Icon(Icons.add),
                          label: Text('Tanque')),
                    ),
                  ],
                ),
              ),
              proprietario.tanques.isEmpty
                  ? SizedBox.shrink()
                  : Container(
                      alignment: Alignment.center,
                      width: larguraTotal * .5,
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: proprietario.tanques.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TanqueWidget(
                              tanque: repo
                                  .findTanque(proprietario.tanques[index])!);
                        },
                      ))
            ],
          ),
        ),
      ),
    );
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

  String? validaCNPJCPF(String? value) {
    if (value == null || value.isEmpty) return 'Informe o CNPJ ou CPF';
    if (value.length != 14 && value.length != 11) return 'CNPJ ou CPF inválido';
    if (!CPF.isValid(value) && !CNPJ.isValid(value))
      return 'CNPJ ou CPF inválido';
    return null;
  }

  bool verificaDadosPreenchidos() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }

  void _insereDadosNoProprietario() {
    proprietario.cnpj = _cCnpjCpf.text;
    proprietario.email = _cEmail.text;
    proprietario.telefone = _cTelefone.text;
    proprietario.razaoSocial = _cRazaSocialProp.text;
  }

  bool _salvaProprietario() {
    if (!verificaDadosPreenchidos()) return false;
    _insereDadosNoProprietario();
    repo.addEmpresa(proprietario);
    Modular.get<MessageController>().setMensagem('proprietario', proprietario);
    setState(() => isSalvo = true);
    return true;
  }

  verificaDadosAlterados() {
    if (isSalvo) {
      setState(() {
        isSalvo = false;
      });
    }
  }
}
