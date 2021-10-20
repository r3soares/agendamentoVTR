import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/tanques_pendentes_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class TanquesPendentesWidget extends StatefulWidget {
  const TanquesPendentesWidget({Key? key}) : super(key: key);

  @override
  _TanquesPendentesWidgetState createState() => _TanquesPendentesWidgetState();
}

class _TanquesPendentesWidgetState extends ModularState<TanquesPendentesWidget, TanquesPendentesStore> {
  final List<TanqueAgendado> tanquesPendentes = List.empty(growable: true);
  final List<Disposer> disposers = List.empty(growable: true);
  final formatoData = 'dd/MM/yy HH:mm';

  @override
  void initState() {
    super.initState();
    var d1 = store.blocTanquesPendentes.observer(onState: _getTanques);
    var d2 = store.blocDiaAtualizado.observer(onState: _remoTanquesDaAgenda);
    store.getTanquesPendentes();

    disposers.addAll([d1, d2]);
  }

  @override
  void dispose() {
    disposers.forEach((d) => d());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '${tanquesPendentes.length} Tanques não agendados',
            style: TextStyle(fontSize: 18),
          ),
        ),
        tanquesPendentes.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: tanquesPendentes.length,
                  itemBuilder: (BuildContext context, int index) {
                    Tanque t = tanquesPendentes.elementAt(index).tanque;
                    final data = DateFormat(formatoData).format(t.dataRegistro);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 12,
                        child: ListTile(
                          leading: TextButton(
                              onPressed: () => {
                                    showDialog(
                                        barrierDismissible: true,
                                        barrierColor: Color.fromRGBO(0, 0, 0, .5),
                                        useSafeArea: true,
                                        context: context,
                                        builder: (_) => VisualizaTanqueDialog(t)),
                                  },
                              child: Icon(Icons.remove_red_eye)),
                          title: Row(children: [
                            Text(
                              t.placa.replaceRange(3, 3, '-'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                '${t.capacidadeTotal.toString()}L (${t.compartimentos.length}C ${_somaSetas(t)}S)',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ]),
                          subtitle: Text('$data'),
                          trailing: TextButton(
                            child: Text('Agendar'),
                            onPressed: () => {tanquesPendentes.elementAt(index)},
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Text('Não há tanques pendentes de agendamento')
      ],
    );
  }

  _getTanques(mb) async {
    tanquesPendentes.clear();
    if (mounted) {
      tanquesPendentes.addAll((mb as ModelBase).model);
      tanquesPendentes.sort((a, b) => a.tanque.dataRegistro.compareTo(b.tanque.dataRegistro));
      setState(() {});
    }
  }

  _remoTanquesDaAgenda(Agenda a) {
    //print('Removendo pendentes...');
    for (var item in a.tanquesAgendados) {
      var ta = tanquesPendentes.firstWhereOrNull((e) => e.id == item.id);
      if (ta != null) {
        tanquesPendentes.remove(ta);
      }
    }
    setState(() {});
  }

  agendaTanque(TanqueAgendado ta) {}

  _somaSetas(Tanque t) {
    return t.compartimentos.fold(0, (int previousValue, element) => previousValue + element.setas);
  }
}
