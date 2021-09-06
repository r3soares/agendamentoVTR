import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DocWidget extends StatefulWidget {
  final Function(Arquivo?, bool) callback;
  final String titulo;
  const DocWidget({this.titulo = 'CRLV ou NF', required this.callback});

  @override
  _DocWidgetState createState() => _DocWidgetState();
}

class _DocWidgetState extends State<DocWidget> {
  Arquivo? _arquivo;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12),
      child: Row(children: [
        ElevatedButton.icon(
          onPressed: () => getFile(),
          icon: Icon(Icons.file_upload),
          label: Text(widget.titulo),
        ),
        Flexible(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 12),
            child: Text(
              _arquivo?.nome ?? '',
              style: TextStyle(fontSize: 10),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]),
    );
  }

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);

    if (result != null) {
      setState(() {
        _arquivo = Arquivo(
          result.files.single.bytes!,
          result.files.single.name,
          result.files.single.extension!,
        );
      });
      widget.callback(_arquivo!, true);
    } else {
      widget.callback(null, false);
    }
  }
}
