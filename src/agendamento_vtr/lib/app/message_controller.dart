import 'dart:collection';

class MessageController {
  final HashMap<String, dynamic> mensagens = HashMap();

  mensagem(String value, {bool apagaAposObter = true}) {
    return apagaAposObter ? mensagens.remove(value) : mensagens[value];
  }

  addMensagem(String nome, value) {
    mensagens[nome] = value;
  }
}
