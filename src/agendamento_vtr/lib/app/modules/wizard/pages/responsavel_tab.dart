import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../wizard_controller.dart';

class ResponsavelTab extends StatefulWidget {
  final TabController tabController;
  const ResponsavelTab(this.tabController);

  @override
  State<ResponsavelTab> createState() => _ResponsavelTabState();
}

class _ResponsavelTabState extends State<ResponsavelTab>
    with AutomaticKeepAliveClientMixin<ResponsavelTab> {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _cEmpresa = TextEditingController();
  final TextEditingController _cNome = TextEditingController();
  final TextEditingController _cEmail = TextEditingController();
  final TextEditingController _cTelefone = TextEditingController();
  final TextEditingController _cObs = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: SizedBox(
        width: 400,
        height: 500,
        child: Card(
          shadowColor: Colors.black,
          elevation: 12,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(12),
                width: 300,
                child: TextFormField(
                  controller: _cNome,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  controller: _cEmpresa,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Empresa',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  controller: _cEmail,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  controller: _cTelefone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Telefone',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  controller: _cObs,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Observação',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 42,
                    icon: Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => widget.tabController
                        .animateTo(widget.tabController.index - 1),
                  ),
                  IconButton(
                    iconSize: 42,
                    icon: Icon(
                      Icons.save_as_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: _salvaAlteracoes,
                  ),
                  IconButton(
                    iconSize: 42,
                    icon: Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => widget.tabController
                        .animateTo(widget.tabController.index + 1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _salvaAlteracoes() {
    var controller = Modular.get<WizardController>();
    controller.dados.update(
      'emailResp',
      (dado) => _cEmail.text,
      ifAbsent: () => _cEmail.text,
    );
    controller.dados.update(
      'empresa',
      (dado) => _cEmpresa.text,
      ifAbsent: () => _cEmpresa.text,
    );
    controller.dados.update(
      'telefoneResp',
      (dado) => _cTelefone.text,
      ifAbsent: () => _cTelefone.text,
    );
    controller.dados.update(
      'nomeResp',
      (dado) => _cNome.text,
      ifAbsent: () => _cNome.text,
    );
    controller.dados.update(
      'obs',
      (dado) => _cObs.text,
      ifAbsent: () => _cObs.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Alterações salvas'),
      backgroundColor: Colors.green.shade700,
    ));
  }
}
