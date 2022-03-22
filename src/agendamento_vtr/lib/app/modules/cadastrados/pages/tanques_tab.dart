import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/stores/tanque_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class TanquesTab extends StatefulWidget {
  const TanquesTab();

  @override
  State<TanquesTab> createState() => _TanquesTabState();
}

class _TanquesTabState extends ModularState<TanquesTab, TanqueStore> {
  @override
  void initState() {
    store.getTanques();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder(
      store: store,
      onState: (context, List<Tanque> tanques) => Center(
        child: tanques.isEmpty
            ? const Text('Sem tanques cadastrados')
            : DataTable(columns: _colunas(), rows: _linhas(tanques)),
      ),
      onLoading: (context) => const CircularProgressIndicator(),
      onError: (context, error) => _erro(),
    );
  }

  Widget _erro() {
    return const Center(
      child: const Text('Erro ao carregar os dados'),
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

  List<DataRow> _linhas(List<Tanque> tanques) {
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
