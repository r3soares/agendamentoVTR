import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ObsTab extends StatefulWidget {
  final Tanque tanque;
  const ObsTab(this.tanque);

  @override
  _ObsTabState createState() => _ObsTabState();
}

class _ObsTabState extends State<ObsTab> {
  final RepositoryTanque repoTanque = Modular.get<RepositoryTanque>();
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
            initialValue: widget.tanque.obs,
            onChanged: (obs) => widget.tanque.obs = obs,
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
      bool salvou = await repoTanque.salvaTanque(widget.tanque);
      if (salvou) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alterações salvas')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Não foi possível salvar as alterações')));
    }
  }
}
