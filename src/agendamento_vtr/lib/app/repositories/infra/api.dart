import 'dart:convert';
import 'dart:io';

import 'package:agendamento_vtr/app/domain/erros.dart';
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
      final req = await _request(tipo: TipoRequest.Delete, uri: uri);
      return _resposta(req);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  getAll() async {
    try {
      final uri = Uri.parse(endereco + controller);
      final req = await _request(tipo: TipoRequest.Get, uri: uri);
      return _resposta(req);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  getById(id) async {
    try {
      final uri = Uri.parse('$endereco$controller/$id');
      final req = await _request(tipo: TipoRequest.Get, uri: uri);
      return _resposta(req);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  find(instrucao, termo) async {
    try {
      final uri = Uri.parse('$endereco$controller/$instrucao/$termo');
      final req = await _request(tipo: TipoRequest.Get, uri: uri);
      return _resposta(req);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  save(data) async {
    try {
      final uri = Uri.parse(endereco + controller);
      final req = await _request(tipo: TipoRequest.Post, uri: uri, data: data);
      return _resposta(req);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  update(data) async {
    try {
      final uri = Uri.parse(endereco + controller);
      final req = await _request(tipo: TipoRequest.Put, uri: uri, data: data);
      return _resposta(req);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  _request({required tipo, required Uri uri, String data = ''}) async {
    try {
      switch (tipo) {
        case TipoRequest.Get:
          {
            return await http.get(uri, headers: this.headers);
          }
        case TipoRequest.Post:
          {
            return await http.post(uri, body: data, headers: this.headers);
          }
        case TipoRequest.Put:
          {
            return await http.post(uri, body: data, headers: this.headers);
          }
        case TipoRequest.Delete:
          {
            return await http.delete(uri, headers: this.headers);
          }
      }
    } on SocketException catch (e) {
      throw new ErroConexao(e.message);
    } on Exception catch (e) {
      throw new Falha(e);
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
          return false;
        }
      case 400: //Bad Request
        {
          throw ErroRequisicao('Bad Request (400)');
        }
      case 404: //Not Found
        {
          throw NaoEncontrado('Not Found (404)');
        }
      case 500: //Internal Server Error
        {
          throw ErroServidor('Internal Server Error (500)'); //Exception('Erro interno do servidor');
        }
    }
    throw Falha('Código de retorno não esperados: ${req.statusCode}');
  }
}

enum TipoRequest { Get, Post, Put, Delete }
