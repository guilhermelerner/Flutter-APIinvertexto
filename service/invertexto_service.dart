import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class InvertextoService {

  final String _token = "21829|XkqHuSXRPKuewLXkQpnJ14WJurdFoOrR";

  Future<Map<String, dynamic>> convertePorExtenso(String? valor, String tipoMoeda) async {
    if (valor == null || valor.isEmpty) {
      return {};
    }

    try {
      final urlString = "https://api.invertexto.com/v1/number-to-words/$valor?token=$_token&type=currency_$tipoMoeda";
      final uri = Uri.parse(urlString);

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buscaCEP(String? valor) async {
    if (valor == null || valor.isEmpty) {
      return {};
    }
    try {
      final urlString = "https://api.invertexto.com/v1/cep/$valor?token=$_token";
      final uri = Uri.parse(urlString);
      
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buscaCNPJ(String? valor) async {
    if (valor == null || valor.isEmpty) {
      return {};
    }
    try {
      final urlString = "https://api.invertexto.com/v1/cnpj/$valor?token=$_token";
      final uri = Uri.parse(urlString);

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet.');
    } catch (e) {
      rethrow;
    }
  }
}