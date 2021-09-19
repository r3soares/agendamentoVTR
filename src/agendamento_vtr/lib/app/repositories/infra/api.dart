import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:agendamento_vtr/app/repositories/IRepository.dart';
import 'package:http/http.dart';

class Api implements IRepository {
  static const String endereco = 'https://localhost:44337/api/vtr/';
  final String controller;
  Api(this.controller);
  @override
  delete(id) async {
    final uri = Uri.parse('$endereco$controller/$id');
    return _resposta(await http.delete(uri));
  }

  @override
  getAll() async {
    final uri = Uri.parse(endereco + controller);
    return _resposta(await http.get(uri));
  }

  @override
  getById(id) async {
    final uri = Uri.parse('$endereco$controller/$id');
    return _resposta(await http.get(uri));
  }

  @override
  find(instrucao, termo) async {
    final uri = Uri.parse('$endereco$controller/$instrucao/$termo');
    return _resposta(await http.get(uri));
  }

  @override
  save(data) async {
    final uri = Uri.parse(endereco + controller);
    return _resposta(await http.post(uri, body: data, headers: {'Content-Type': 'application/json'}));
  }

  @override
  update(data) async {
    final uri = Uri.parse(endereco + controller);
    return _resposta(await http.put(uri, body: data, headers: {'Content-Type': 'application/json'}));
  }

  _resposta(Response req) {
    if (req.statusCode != 200) return null;
    return req.body.length > 3 ? jsonDecode(req.body) : null;
  }
}
