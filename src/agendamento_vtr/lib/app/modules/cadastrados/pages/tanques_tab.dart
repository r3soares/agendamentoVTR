import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
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
  int _indexColuna = 0;
  bool _isAscendente = false;
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
            : ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: SingleChildScrollView(
                    child: DataTable(
                        sortAscending: _isAscendente,
                        sortColumnIndex: _indexColuna,
                        columns: _colunas(tanques),
                        rows: _linhas(tanques)))),
      ),
      onLoading: (context) => const Center(
        child: const CircularProgressIndicator(),
      ),
      onError: (context, error) => _erro(),
    );
  }

  Widget _erro() {
    return const Center(
      child: const Text('Erro ao carregar os dados'),
    );
  }

  List<DataColumn> _colunas(List<Tanque> tanques) {
    return [
      DataColumn(
          label: const Text('Placa'),
          onSort: (index, isAscentente) =>
              _ordenaPlaca(tanques, index, isAscentente)),
      DataColumn(
          label: const Text('Inmetro'),
          onSort: (index, isAscentente) =>
              _ordenaInmetro(tanques, index, isAscentente)),
      DataColumn(
          label: const Text('Capacidade (L)'),
          onSort: (index, isAscentente) =>
              _ordenaCapacidade(tanques, index, isAscentente)),
      DataColumn(
          label: const Text('Compartimentos'),
          onSort: (index, isAscentente) =>
              _ordenaCompartimentos(tanques, index, isAscentente)),
      const DataColumn(label: const Text('Setas')),
    ];
  }

  _ordenaPlaca(List tanques, index, isAscendente) => setState(() => {
        _indexColuna = index,
        _isAscendente = isAscendente,
        isAscendente
            ? tanques.sort((a, b) => a.placa.compareTo(b.placa))
            : tanques.sort((b, a) => a.placa.compareTo(b.placa))
      });
  _ordenaInmetro(List<Tanque> tanques, index, isAscendente) => setState(() => {
        _indexColuna = index,
        _isAscendente = isAscendente,
        isAscendente
            ? tanques.sort((a, b) => a.codInmetro.compareTo(b.codInmetro))
            : tanques.sort((b, a) => a.codInmetro.compareTo(b.codInmetro))
      });
  _ordenaCapacidade(List<Tanque> tanques, index, isAscendente) =>
      setState(() => {
            _indexColuna = index,
            _isAscendente = isAscendente,
            isAscendente
                ? tanques.sort(
                    (a, b) => a.capacidadeTotal.compareTo(b.capacidadeTotal))
                : tanques.sort(
                    (b, a) => a.capacidadeTotal.compareTo(b.capacidadeTotal))
          });
  _ordenaCompartimentos(List<Tanque> tanques, index, isAscendente) =>
      setState(() => {
            _indexColuna = index,
            _isAscendente = isAscendente,
            isAscendente
                ? tanques.sort((a, b) =>
                    a.compartimentos.length.compareTo(b.compartimentos.length))
                : tanques.sort((b, a) =>
                    a.compartimentos.length.compareTo(b.compartimentos.length))
          });

  // _ordenaSetas(List<Tanque> tanques, index, isAscendente) => setState(() => {
  //       _indexColuna = index,
  //       _isAscendente = isAscendente,
  //       isAscendente
  //           ? tanques.sort((a, b) => a.totalSetas.compareTo(b.totalSetas))
  //           : tanques.sort((b, a) => a.totalSetas.compareTo(b.totalSetas))
  //     });

  List<DataRow> _linhas(List<Tanque> tanques) {
    List<DataRow> linhas = List.empty(growable: true);
    int contador = 0;
    for (Tanque tanque in tanques) {
      contador++;
      DataRow linha = DataRow(
          cells: [
            DataCell(Text(tanque.placa)),
            DataCell(Text(tanque.codInmetro)),
            DataCell(Text(tanque.capacidadeTotal.toString())),
            DataCell(Text(tanque.compartimentos.length.toString())),
            DataCell(Text(tanque.totalSetas.toString())),
          ],
          color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            // All rows will have the same selected color.
            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
            }
            // Even rows will have a grey color.
            if (contador.isEven) {
              return Colors.grey.withOpacity(0.3);
            }
            return null; // Use default value for other states and odd rows.
          }));
      linhas.add(linha);
    }
    return linhas;
  }
}
