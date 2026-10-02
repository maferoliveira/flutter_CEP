import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCepService {
  Future<Map<String, dynamic>?> buscarCep(String cep) async {
    cep = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cep.length != 8) {
      return null;
    }

    final url = Uri.parse(
      'https://viacep.com.br/ws/$cep/json/',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dados = jsonDecode(response.body);

        if (dados['erro'] == true) {
          return null;
        }

        return dados;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}