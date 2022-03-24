import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/stores/empresa_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class EmpresasTab extends StatefulWidget {
  const EmpresasTab();

  @override
  State<EmpresasTab> createState() => _EmpresasTabState();
}

class _EmpresasTabState extends ModularState<EmpresasTab, EmpresaStore> {
  @override
  void initState() {
    store.getEmpresas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder(
      store: store,
      onState: (context, List<Empresa> empresas) => Center(
          child: empresas.isEmpty
              ? const Text('Sem empresas cadastradas')
              : ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: SingleChildScrollView(
                    child:
                        DataTable(columns: _colunas(), rows: _linhas(empresas)),
                  ))),
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
      const DataColumn(label: const Text('CNPJ')),
      const DataColumn(label: const Text('Razão Social')),
      // const DataColumn(label: const Text('Capacidade (L)')),
      // const DataColumn(label: const Text('Compartimentos')),
      // const DataColumn(label: const Text('Setas')),
    ];
  }

  List<DataRow> _linhas(List<Empresa> empresas) {
    List<DataRow> linhas = List.empty(growable: true);
    for (Empresa e in empresas) {
      DataRow linha = DataRow(cells: [
        DataCell(Text(e.cnpjFormatado)),
        DataCell(Text(e.razaoSocial)),
        // DataCell(Text(tanque.capacidadeTotal.toString())),
        // DataCell(Text(tanque.compartimentos.length.toString())),
        // DataCell(Text(tanque.totalSetas.toString())),
      ]);
      linhas.add(linha);
    }
    return linhas;
  }
}
