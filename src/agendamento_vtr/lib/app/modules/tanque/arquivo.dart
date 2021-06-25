import 'dart:typed_data';

class Arquivo {
  final Uint8List dados;
  final String nome;
  final String extensao;

  Arquivo(this.dados, this.nome, this.extensao);
}
