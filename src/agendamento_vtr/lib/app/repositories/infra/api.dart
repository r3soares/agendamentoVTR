import 'dart:convert';

import 'package:agendamento_vtr/app/models/compartimento.dart';
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
    switch (req.statusCode) {
      case 200: //Ok
        {
          return jsonDecode(req.body, reviver: (key, value) {
            switch (key) {
              case "compartimentos":
                {
                  return (value as List).map((e) => Compartimento.fromJson(e)).toList();
                }
            }
            return value;
          });
        }
      case 202: //Accepted
        {
          return true;
        }
      case 204: //No Content
        {
          return null;
        }
      case 400: //Bad Request
        {
          return false; //Exception('Bad Request');
        }
      case 404: //Not Found
        {
          return null;
        }
      case 500: //Internal Server Error
        {
          return false; //Exception('Erro interno do servidor');
        }
    }
  }
}
