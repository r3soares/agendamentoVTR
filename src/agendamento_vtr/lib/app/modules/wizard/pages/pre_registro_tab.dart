import 'package:agendamento_vtr/app/domain/extensions.dart';
import 'package:agendamento_vtr/app/modules/wizard/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PreRegistroTab extends StatefulWidget {
  final TabController tabController;
  const PreRegistroTab(this.tabController);

  @override
  State<PreRegistroTab> createState() => _PreRegistroTabState();
}

class _PreRegistroTabState extends State<PreRegistroTab>
    with AutomaticKeepAliveClientMixin<PreRegistroTab> {
  final TextEditingController _cData = TextEditingController();
  final TextEditingController _cHora = TextEditingController();
  final TextEditingController _cPlaca1 = TextEditingController();
  final TextEditingController _cPlaca2 = TextEditingController();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 400,
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
                  controller: _cData,
                  onTap: () => showDialog(
                          barrierDismissible: true,
                          barrierColor: Color.fromRGBO(0, 0, 0, .5),
                          useSafeArea: true,
                          context: context,
                          builder: (_) => _showCalendarioWidget())
                      .then((data) => _atualizaData(data)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Data do agendamento',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  controller: _cHora,
                  onTap: () => showDialog(
                          barrierDismissible: true,
                          barrierColor: Color.fromRGBO(0, 0, 0, .5),
                          useSafeArea: true,
                          context: context,
                          builder: (_) => _showHoraWidget())
                      .then((data) => _atualizaHora(data)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hora do agendamento',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  controller: _cPlaca1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Informe a placa 1',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  controller: _cPlaca2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Informe a placa 2 (se bitrem)',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

  _showCalendarioWidget() {
    return DatePickerDialog(
        fieldLabelText: "Informe a data da solicitação",
        helpText: 'Data Selecionada',
        initialDate: DateTime.now(),
        firstDate: DateTime.now().add(Duration(days: -365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
  }

  _showHoraWidget() {
    return TimePickerDialog(
      hourLabelText: 'Hora',
      minuteLabelText: 'Minutos',
      helpText: "Informe a hora do agendamento",
      initialTime: TimeOfDay.now(),
    );
  }

  _atualizaData(DateTime? data) {
    if (data == null) return;
    setState(() => {_cData.text = (data as DateTime).diaMesAnoToString()});
  }

  _atualizaHora(TimeOfDay? data) {
    if (data == null) return;
    setState(() => {_cHora.text = (data as TimeOfDay).format(context)});
  }

  _salvaAlteracoes() {
    var controller = Modular.get<WizardController>();
    controller.dados
        .update('data', (dado) => _cData.text, ifAbsent: () => _cData.text);
    controller.dados
        .update('hora', (dado) => _cHora.text, ifAbsent: () => _cHora.text);
    controller.dados.update('placa1', (dado) => _cPlaca1.text,
        ifAbsent: () => _cPlaca1.text);
    controller.dados.update('placa2', (dado) => _cPlaca2.text,
        ifAbsent: () => _cPlaca2.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Alterações salvas'),
      backgroundColor: Colors.green.shade700,
    ));
  }
}
