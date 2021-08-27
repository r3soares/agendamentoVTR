import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CrlvNfWidget extends StatefulWidget {
  final Tanque tanque;
  const CrlvNfWidget(this.tanque);

  @override
  _CrlvNfWidgetState createState() => _CrlvNfWidgetState();
}

class _CrlvNfWidgetState extends State<CrlvNfWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12),
      child: Row(children: [
        ElevatedButton.icon(
          onPressed: () => getFile(),
          icon: Icon(Icons.file_upload),
          label: Text('CRLV ou NF'),
        ),
        Flexible(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 12),
            child: Text(
              widget.tanque.doc?.nome ?? '',
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
        widget.tanque.doc = Arquivo(
          result.files.single.bytes!,
          result.files.single.name,
          result.files.single.extension!,
        );
      });
    } else {
      // User canceled the picker
    }
  }
}
