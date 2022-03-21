import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:flutter/material.dart';

class TanquesTab extends StatelessWidget {
  final tanques;
  const TanquesTab(this.tanques);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: tanques.isEmpty
          ? const Text('Sem tanques cadastrados')
          : DataTable(columns: _colunas(), rows: _linhas()),
    );
  }

  List<DataColumn> _colunas() {
    return const [
      const DataColumn(label: const Text('Placa')),
      const DataColumn(label: const Text('Inmetro')),
      const DataColumn(label: const Text('Capacidade (L)')),
      const DataColumn(label: const Text('Compartimentos')),
      const DataColumn(label: const Text('Setas')),
    ];
  }

  List<DataRow> _linhas() {
    List<DataRow> linhas = List.empty(growable: true);
    for (Tanque tanque in tanques) {
      DataRow linha = DataRow(cells: [
        DataCell(Text(tanque.placaFormatada)),
        DataCell(Text(tanque.codInmetro)),
        DataCell(Text(tanque.capacidadeTotal.toString())),
        DataCell(Text(tanque.compartimentos.length.toString())),
        DataCell(Text(tanque.totalSetas.toString())),
      ]);
      linhas.add(linha);
    }
    return linhas;
  }
}
