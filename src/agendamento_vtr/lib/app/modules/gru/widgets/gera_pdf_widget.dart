import 'package:agendamento_vtr/app/modules/gru/models/tanque_servico.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:agendamento_vtr/app/domain/extensions.dart';

class GeraPdfWidget extends StatelessWidget {
  final TanqueServico tanqueServico;
  const GeraPdfWidget(this.tanqueServico);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  geraPdf() async {
    final pw.Document doc = pw.Document();
    await Future.delayed(Duration(milliseconds: 100));
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(0),
        header: (context) => _buildHeader(context),
        footer: (context) => _buildFooter(context),
        build: (context) => _buildBody(context),
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  _buildHeader(pw.Context context) {
    return pw.Container(
        height: 150,
        child: pw.Padding(
            padding: pw.EdgeInsets.all(16),
            child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Relatório para emissão de GRU', style: pw.TextStyle(fontSize: 22, color: PdfColors.black)),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('VTR', style: pw.TextStyle(fontSize: 22, color: PdfColors.black)),
                      pw.Text('Itajaí', style: pw.TextStyle(color: PdfColors.black)),
                    ],
                  )
                ])));
  }

  _buildFooter(pw.Context context) {
    return pw.Container();
  }

  List<pw.Widget> _buildBody(pw.Context context) {
    return [
      pw.Padding(padding: pw.EdgeInsets.only(top: 30, left: 25, right: 25), child: _buildContentClient()),
      pw.Padding(padding: pw.EdgeInsets.only(top: 50, left: 25, right: 25), child: _contentTable(context)),
    ];
  }

  pw.Widget _buildContentClient() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _titleText('Data'),
          pw.Text(DateTime.now().diaHoraToString()),
        ],
      ),
    ]);
  }

  _titleText(String text) {
    return pw.Padding(
        padding: pw.EdgeInsets.only(top: 8),
        child: pw.Text(text, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)));
  }

  /// Constroi uma tabela com base nos produtos da fatura
  pw.Widget _contentTable(pw.Context context) {
    // Define uma lista usada no cabeçalho
    const tableHeaders = ['Placa', 'Município', 'Proprietário', 'Q x Cod = Custo', 'Custo Total', 'Inmetro'];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(1)),
      ),
      headerHeight: 30,
      cellHeight: 40,
      columnWidths: {
        0: pw.FixedColumnWidth(50),
        1: pw.FixedColumnWidth(80),
        2: pw.FixedColumnWidth(100),
        3: pw.FixedColumnWidth(110),
        4: pw.FixedColumnWidth(60),
        5: pw.FixedColumnWidth(50),
      },
      // Define o alinhamento das células, onde a chave é a coluna
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerLeft,
        5: pw.Alignment.center,
      },
      // Define um estilo para o cabeçalho da tabela
      headerStyle: pw.TextStyle(
        fontSize: 10,
        color: PdfColors.blue,
        fontWeight: pw.FontWeight.bold,
      ),
      rowDecoration: const pw.BoxDecoration(
          border: pw.Border(
        bottom: pw.BorderSide(width: 1, color: PdfColors.grey),
        right: pw.BorderSide(width: 1, color: PdfColors.grey),
        left: pw.BorderSide(width: 1, color: PdfColors.grey),
      )),
      cellDecoration: (index, data, rowNum) => pw.BoxDecoration(
          color: rowNum % 2 == 0 ? PdfColors.grey300 : PdfColors.white,
          border: pw.Border(
            bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey),
            right: pw.BorderSide(width: 0.5, color: PdfColors.grey),
            left: pw.BorderSide(width: 0.5, color: PdfColors.grey),
          )),
      // Define um estilo para a célula
      cellStyle: const pw.TextStyle(
        fontSize: 11,
      ),
      headers: tableHeaders,
      // retorna os valores da tabela, de acordo com a linha e a coluna
      data: List<List<String>>.generate(
        tanqueServico.tanques.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => _getValueIndex(row, col),
        ),
      ),
    );
  }

  /// Retorna o valor correspondente a coluna
  String _getValueIndex(int row, int col) {
    switch (col) {
      case 0:
        return tanqueServico.getPlaca(row);
      case 1:
        return tanqueServico.getMun(row);
      case 2:
        return tanqueServico.getProp(row);
      case 3:
        return tanqueServico.geraCodigosServicos(row);
      case 5:
        return tanqueServico.getInmetro(row).toString();
      case 4:
        return _formatValue(tanqueServico.getCustoTotal(row));
    }
    return '';
  }

  /// Formata o valor informado na formatação pt/BR
  String _formatValue(double value) {
    final NumberFormat numberFormat = new NumberFormat("R\$ #,##0.00", "pt_BR");
    return numberFormat.format(value);
  }

  /// Retorna o QrCode da fatura
  pw.Widget _buildQrCode(pw.Context context) {
    return pw.Container(
        height: 65,
        width: 65,
        child: pw.BarcodeWidget(
            barcode: pw.Barcode.fromType(pw.BarcodeType.QrCode), data: 'nada a declarar kct', color: PdfColors.white));
  }

  /// Retorna o rodapé da página
  pw.Widget _buildPrice(pw.Context context) {
    return pw.Container(
      color: PdfColors.blue,
      height: 130,
      child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Padding(
                padding: pw.EdgeInsets.only(left: 16),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      _buildQrCode(context),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(top: 12),
                          child:
                              pw.Text('Use esse QR para pagar', style: pw.TextStyle(color: PdfColor(0.85, 0.85, 0.85))))
                    ])),
            pw.Padding(
                padding: pw.EdgeInsets.all(16),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Padding(
                          padding: pw.EdgeInsets.only(bottom: 0),
                          child: pw.Text('TOTAL', style: pw.TextStyle(color: PdfColors.white))),
                      pw.Text('R\$: 0}', style: pw.TextStyle(color: PdfColors.white, fontSize: 22))
                    ]))
          ]),
    );
  }
}
