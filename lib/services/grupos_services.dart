import 'dart:convert';
import 'package:flutter_application_3/models/grupos_model.dart';
import 'package:http/http.dart' as http;

class GruposService {
  final baseUrl = Uri.parse('http://10.0.2.2:5282/api/Grupo/Lista');
  final baseUr2 = Uri.parse('http://10.0.2.2:5282/api/Grupo/Guardar');
  final baseUr3 = Uri.parse('http://10.0.2.2:5282/api/Grupo/Editar');
  final baseUr4 = Uri.parse('http://10.0.2.2:5282/api/Grupo/Eliminar');

  Future<List<Grupo>> getGrupo() async {
    final response = await http.get(baseUrl);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final grupoResponse = GrupoResponse.fromJson(jsonData);

      if (grupoResponse.respuesta != null) {
        return grupoResponse.respuesta!;
      } else {
        throw Exception('No se encontraron datos de los grupos');
      }
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future<bool> postGrupo({required Grupo grupo}) async {
    try {
      final response = await http.post(
        (baseUr2),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(grupo.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error al realizar la inserción');
    }
  }

  Future<bool> putGrupo({required Grupo grupo}) async {
    print(grupo.idGrupo);
    try {
      final response = await http.put(
        baseUr3,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          "idGrupo": grupo.idGrupo,
          "horario": grupo.horario,
          "idMaestro": grupo.idMaestro,
          "numeroIntegrantes": grupo.numeroIntegrantes,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error al realizar la actualización');
    }
  }

  Future<bool> deleteGrupo({required int idGrupo}) async {
    try {
      final response = await http.delete(Uri.parse('$baseUr4/$idGrupo'));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error al realizar la eliminación');
    }
  }
}
