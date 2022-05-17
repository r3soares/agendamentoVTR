import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../wizard_controller.dart';

class ProprietarioTab extends StatefulWidget {
  final TabController tabController;
  const ProprietarioTab(this.tabController);

  @override
  State<ProprietarioTab> createState() => _ProprietarioTabState();
}

class _ProprietarioTabState extends State<ProprietarioTab>
    with AutomaticKeepAliveClientMixin<ProprietarioTab> {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _cCnpj = TextEditingController();
  final TextEditingController _cNome = TextEditingController();
  final TextEditingController _cMunicipio = TextEditingController();
  final TextEditingController _cCodProprietario = TextEditingController();
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
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  controller: _cCnpj,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CNPJ',
                  ),
                ),
              ),
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
                  controller: _cMunicipio,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Município',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  controller: _cCodProprietario,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Número do proprietário',
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
      'cnpj',
      (dado) => _cCnpj.text,
      ifAbsent: () => _cCnpj.text,
    );
    controller.dados.update(
      'codProprietario',
      (dado) => _cCodProprietario.text,
      ifAbsent: () => _cCodProprietario.text,
    );
    controller.dados.update(
      'codMunicipio',
      (dado) => _cMunicipio.text,
      ifAbsent: () => _cMunicipio.text,
    );
    controller.dados.update(
      'nomeProp',
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
