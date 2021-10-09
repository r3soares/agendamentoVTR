import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/reagenda_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class ReagendaDialog extends StatefulWidget {
  final TanqueAgendado tAgendado;
  const ReagendaDialog(this.tAgendado);

  @override
  State<ReagendaDialog> createState() => _ReagendaDialogState();
}

class _ReagendaDialogState extends ModularState<ReagendaDialog, ReagendaStore> {
  final focusNode = FocusNode();
  final TextEditingController _cCampo = TextEditingController();
  final MaskTextInputFormatter _mascara =
      new MaskTextInputFormatter(mask: '##-##-####', filter: {"#": RegExp(r'[0-9]')});
  String _ultimaDataValida = '';
  Agenda? aNova;
  Agenda? aVelha;

  @override
  void initState() {
    super.initState();
    store.blocAgendaAntiga.observer(
        onState: (e) => setState(() {
              aVelha = (e as ModelBase).model;
            }));
    store.getAgendaAntiga(widget.tAgendado.agenda);
    store.blocAgendaNova.observer(
        onState: (e) => setState(() {
              aNova = (e as ModelBase).model;
              _ultimaDataValida = aNova!.data;
            }));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: size.width * .5,
        height: size.height * .6,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    //icon: Image.asset('assets/images/inmetro.png'),
                    icon: Icon(Icons.calendar_today_outlined),
                    hintText: 'Informe a nova data',
                    hintStyle: TextStyle(fontSize: 10),
                    labelText: 'Reagendamento',
                  ),
                  inputFormatters: [_mascara],
                  controller: _cCampo,
                  validator: validaInput,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed:
                    aNova == null || aVelha == null || aNova!.status != StatusAgenda.Disponivel ? null : reagendaTanque,
                child: Text('Reagendar'),
              ),
            )
          ],
        ),
      ),
    );
  }

  String? validaInput(String? value) {
    if (value == null || value.isEmpty) return 'Informe uma data';
    if (_mascara.getUnmaskedText().length < 8) return 'Informe a data no formato dd/mm/aaaa';
    if (_ultimaDataValida != value) {
      store.getAgendaNova(value);
    }
    return null;
  }

  void reagendaTanque() {
    TanqueAgendado taVelho = widget.tAgendado;
    TanqueAgendado taNovo = TanqueAgendado(id: Uuid().v1(), tanque: taVelho.tanque, agenda: aNova!.data);
    store.reagenda(taVelho, taNovo, aVelha!, aNova!);
  }
}
