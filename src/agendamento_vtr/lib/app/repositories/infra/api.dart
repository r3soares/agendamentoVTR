import 'package:http/http.dart' as http;

import 'package:agendamento_vtr/app/repositories/IRepository.dart';

class Api implements IRepository {
  static const String endereco = 'https://localhost:44337/api/vtr/';
  final String controller;
  Api(this.controller);
  @override
  delete(id) async {
    final uri = Uri.parse(endereco + controller + id);
    return await http.delete(uri);
  }

  @override
  getAll() async {
    final uri = Uri.parse(endereco + controller);
    return await http.get(uri);
  }

  @override
  getById(id) async {
    final uri = Uri.parse(endereco + controller + id);
    return await http.get(uri);
  }

  @override
  save(data) async {
    final uri = Uri.parse(endereco + controller);
    return await http
        .post(uri, body: data, headers: {'Content-Type': 'application/json'});
  }

  @override
  update(data) async {
    final uri = Uri.parse(endereco + controller);
    return await http
        .put(uri, body: data, headers: {'Content-Type': 'application/json'});
  }
}
