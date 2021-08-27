import 'dart:collection';

class MessageController {
  final HashMap<String, dynamic> _mensagens = HashMap();

  mensagem(String value) {
    return _mensagens[value];
  }

  setMensagem(String nome, value) {
    _mensagens[nome] = value;
  }

  limpaMensagens() {
    _mensagens.clear();
  }
}
