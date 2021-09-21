import 'dart:convert';

import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:http/http.dart' as http;

import 'package:agendamento_vtr/app/repositories/IRepository.dart';
import 'package:http/http.dart';

class Api implements IRepository {
  static const String endereco = 'https://localhost:44337/api/vtr/';
  final String controller;
  final headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, DELETE, PUT',
    'Access-Control-Allow-Headers': 'X-Requested-With'
  };
  Api(this.controller);
  @override
  delete(id) async {
    try {
      final uri = Uri.parse('$endereco$controller/$id');
      return _resposta(await http.delete(uri, headers: this.headers));
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  getAll() async {
    try {
      final uri = Uri.parse(endereco + controller);
      return _resposta(await http.get(uri, headers: this.headers));
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  getById(id) async {
    try {
      final uri = Uri.parse('$endereco$controller/$id');
      return _resposta(await http.get(uri, headers: this.headers));
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  find(instrucao, termo) async {
    try {
      final uri = Uri.parse('$endereco$controller/$instrucao/$termo');
      return _resposta(await http.get(uri, headers: this.headers));
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  save(data) async {
    try {
      final uri = Uri.parse(endereco + controller);
      return _resposta(await http.post(uri, body: data, headers: this.headers));
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  update(data) async {
    try {
      final uri = Uri.parse(endereco + controller);
      return _resposta(await http.put(uri, body: data, headers: this.headers));
    } catch (e) {
      print(e);
      return false;
    }
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
