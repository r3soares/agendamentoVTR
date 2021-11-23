import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter/material.dart';

class StatusTab extends StatelessWidget {
  final TanqueAgendado tAgendado;
  const StatusTab(this.tAgendado);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Confirmação ',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: buildStatusConfirmacao(),
            )
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Pagamento',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: buildStatusPagamento(),
            )
          ],
        )
      ],
    );
  }

  Widget buildStatusConfirmacao() {
    var statusC = getStatusConfirmacao();

    return TextButton(
        onPressed: () => {},
        child: Text(
          statusC.key,
          style: TextStyle(color: statusC.value),
        ));
  }

  Widget buildStatusPagamento() {
    var statusP = getStatusPagamento(tAgendado.statusPagamento);
    return TextButton(
        onPressed: () => {},
        child: Text(
          statusP.key,
          style: TextStyle(color: statusP.value),
        ));
  }

  MapEntry<String, Color> getStatusConfirmacao() {
    var status = tAgendado.statusConfirmacao;
    switch (status) {
      case StatusConfirmacao.PreAgendado:
        return MapEntry('Fila de Espera', Colors.deepPurple);
      case StatusConfirmacao.NaoConfirmado:
        return MapEntry('Aguardando confirmação para o dia ${tAgendado.agenda}', Colors.orange);
      case StatusConfirmacao.Confirmado:
        return MapEntry('Confirmado para o dia ${tAgendado.agenda}', Colors.green);
      case StatusConfirmacao.Reagendado:
        return MapEntry('Reagendado para o dia ${tAgendado.agenda}', Colors.blue.shade900);
      case StatusConfirmacao.Cancelado:
        return MapEntry('Cancelado para o dia ${tAgendado.agenda}', Colors.red);
    }
  }

  MapEntry<String, Color> getStatusPagamento(StatusPagamento status) {
    switch (status) {
      case StatusPagamento.Atrasado:
        return MapEntry('Atrasado', Colors.red.shade900);
      case StatusPagamento.Confirmado:
        return MapEntry('Confirmado', Colors.green);
      case StatusPagamento.Pendente:
        return MapEntry('Pendente', Colors.orange);
    }
  }
}
