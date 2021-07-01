import 'package:agendamento_vtr/app/modules/tanque/models/proprietario.dart';
import 'package:agendamento_vtr/app/modules/tanque/pages/tanque_dialog.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_widget.dart';
import 'package:agendamento_vtr/app/modules/util/cnpj.dart';
import 'package:agendamento_vtr/app/modules/util/cpf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FormularioWidget extends StatefulWidget {
  const FormularioWidget({Key? key}) : super(key: key);

  @override
  _FormularioWidgetState createState() => _FormularioWidgetState();
}

class _FormularioWidgetState extends State<FormularioWidget> {
  final _formKey = GlobalKey<FormState>();

  final formulario = Modular.get<Proprietario>();

  final TextEditingController _cRazaSocialProp = TextEditingController();

  final TextEditingController _cCnpjCpf = TextEditingController();

  final TextEditingController _cOficina = TextEditingController();

  final TextEditingController _cEmail = TextEditingController();

  _FormularioWidgetState() {
    formulario.addListener(() {
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
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    controller: _cCnpjCpf,
                    validator: validaCNPJCPF,
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Razão Social ou Nome do Proprietário',
                    ),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
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
                    decoration: const InputDecoration(
                      icon: Icon(Icons.other_houses),
                      hintText: 'Oficina que realizou o agendamento',
                      hintStyle: TextStyle(fontSize: 10),
                      labelText: 'Nome da oficina credenciada, se houver',
                    ),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    controller: _cOficina,
                  )),
              Padding(
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
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text('Enviar'),
                        onPressed: verificaDadosPreenchidos() ? () => {} : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          onPressed: () => showDialog(
                              barrierDismissible: false,
                              barrierColor: Color.fromRGBO(0, 0, 0, .5),
                              useSafeArea: true,
                              context: context,
                              builder: (_) => const TanqueDialog()),
                          icon: Icon(Icons.add),
                          label: Text('Tanque')),
                    ),
                  ],
                ),
              ),
              formulario.tanques.isEmpty
                  ? SizedBox.shrink()
                  : Container(
                      alignment: Alignment.center,
                      width: larguraTotal * .5,
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: formulario.tanques.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(index);
                          return TanqueWidget(
                              tanque: formulario.tanques[index]);
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
    return _formKey.currentState!.validate() && formulario.tanques.isNotEmpty;
  }
}
