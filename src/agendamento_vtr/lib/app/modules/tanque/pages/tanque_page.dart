import 'package:agendamento_vtr/app/modules/empresa/controllers/empresa_controller.dart';
import 'package:agendamento_vtr/app/modules/tanque/pages/tanque_dialog.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TanquePage extends StatefulWidget {
  const TanquePage({Key? key}) : super(key: key);

  @override
  _TanquePageState createState() => _TanquePageState();
}

class _TanquePageState extends State<TanquePage> {
  final _formKey = GlobalKey<FormState>();

  final controller = Modular.get<EmpresaController>();

  final TextEditingController _cRazaSocialProp = TextEditingController();

  final TextEditingController _cTelefone = TextEditingController();

  final TextEditingController _cEmail = TextEditingController();

  bool isPropEditavel = false;

  _TanquePageState() {
    controller.empresa.addListener(() {
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
                "Dados do Proprietário",
                style: TextStyle(fontSize: 20),
              )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: !controller.isSalvo,
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
                  enabled: !controller.isSalvo,
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
                child: controller.isSalvo
                    ? ElevatedButton.icon(
                        onPressed: () => setState(() => isPropEditavel = true),
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
                        onPressed: isPropEditavel || !controller.isSalvo
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
                          onPressed: !isPropEditavel && controller.isSalvo
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
              controller.empresa.tanques.isEmpty
                  ? SizedBox.shrink()
                  : Container(
                      alignment: Alignment.center,
                      width: larguraTotal * .5,
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.empresa.tanques.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TanqueWidget(
                              placa: controller.empresa.tanques[index]);
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

  bool _salvaProprietario() {
    if (!verificaDadosPreenchidos()) return false;
    _insereDadosNoProprietario();
    controller.salvaEmpresa();
    setState(() => isPropEditavel = true);
    return true;
  }
}
