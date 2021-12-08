import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ObsTab extends StatefulWidget {
  final TanqueAgendado tAgendado;
  const ObsTab(this.tAgendado);

  @override
  _ObsTabState createState() => _ObsTabState();
}

class _ObsTabState extends State<ObsTab> {
  final RepositoryTanqueAgendado repoTa = Modular.get<RepositoryTanqueAgendado>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Veículo',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextFormField(
            initialValue: widget.tAgendado.tanque.obs,
            onChanged: (obs) => widget.tAgendado.tanque.obs = obs,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
                isDense: true,
                hintText: 'Anotações do veículo',
                hintMaxLines: 10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                )),
          ),
        ),
        widget.tAgendado.agenda == null
            ? SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Agenda Atual ${widget.tAgendado.agenda}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextFormField(
                      initialValue: widget.tAgendado.obs,
                      onChanged: (obs) => widget.tAgendado.obs = obs,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Anotações do veículo para a agenda atual (${widget.tAgendado.agenda})',
                          hintMaxLines: 10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          )),
                    ),
                  ),
                ],
              ),
        Center(
          child: ElevatedButton(
            child: Text('Salvar'),
            onPressed: () => _salvaAlteracoes(context),
          ),
        )
      ],
    );
  }

  _salvaAlteracoes(BuildContext context) async {
    try {
      bool salvou = await repoTa.save(widget.tAgendado);
      if (salvou) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alterações salvas')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Não foi possível salvar as alterações')));
    }
  }
}
