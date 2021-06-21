import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormularioWidget extends StatelessWidget {
  final String title;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cRazaSocialProp = TextEditingController();
  final TextEditingController _cCnpjCpf = TextEditingController();
  final TextEditingController _cOficina = TextEditingController();
  final TextEditingController _cEmail = TextEditingController();

  FormularioWidget({Key? key, this.title = "FormularioWidget"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: larguraTotal / 4),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Text(
              title,
              style: TextStyle(fontSize: 20),
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
                  validator: (String? value) {
                    return (value != null &&
                            (value.length == 14 || value.length == 11))
                        ? null
                        : 'CNPJ ou CPF inválido';
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
                      onPressed: () => {
                        if (_formKey.currentState!.validate())
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tanque inserido')))
                          }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                        onPressed: () => showDialog(
                            barrierColor: Color.fromRGBO(0, 0, 0, .5),
                            useSafeArea: true,
                            context: context,
                            builder: (_) => TanqueDialogWidget()),
                        icon: Icon(Icons.add),
                        label: Text('Tanque')),
                  ),
                ],
              ),
            )
          ],
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
}
