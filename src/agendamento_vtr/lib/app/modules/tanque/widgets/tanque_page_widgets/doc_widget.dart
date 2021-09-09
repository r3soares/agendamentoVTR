import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DocWidget extends StatefulWidget {
  final Function(List<Arquivo>) callback;
  final List<Arquivo>? arquivosPrevio;
  final String titulo;
  DocWidget(
      {this.titulo = 'CRLV ou NF',
      this.arquivosPrevio,
      required this.callback});

  @override
  _DocWidgetState createState() => _DocWidgetState();
}

class _DocWidgetState extends State<DocWidget> {
  late List<Arquivo> _arquivos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _arquivos = widget.arquivosPrevio ?? List.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Row(children: [
        ElevatedButton.icon(
          onPressed: () => getFile(),
          icon: Icon(Icons.file_upload),
          label: Text(widget.titulo),
        ),
        SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(8),
              child: _arquivos.isEmpty
                  ? SizedBox.shrink()
                  : Card(
                      elevation: 4,
                      shadowColor: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Arquivos Anexados',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: size.width * .2,
                            height: size.height * .15,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _arquivos.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return Container(
                                  alignment: Alignment.center,
                                  width: size.width * 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: size.width * .1,
                                        child: Text(
                                          _arquivos[index].nome,
                                          style: TextStyle(fontSize: 10),
                                          softWrap: false,
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () => {_removeFile(index)},
                                          child: Text(
                                            'X',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.red[900]),
                                          )),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
        ),
      ]),
    );
  }

  void _removeFile(int index) {
    setState(() {
      _arquivos.removeAt(index);
    });
    widget.callback(_arquivos);
  }

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);

    if (result != null) {
      setState(() {
        result.files.forEach((element) {
          _arquivos.add(Arquivo(result.files.single.bytes!,
              result.files.single.name, result.files.single.extension!));
        });
      });
      widget.callback(_arquivos);
    }
  }
}
