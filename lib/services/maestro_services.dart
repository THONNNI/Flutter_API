import 'dart:convert';
import 'package:flutter_application_3/models/maestros_model.dart';
import 'package:http/http.dart' as http;

class MaestrosService {
  final baseUrl = Uri.parse('http://10.0.2.2:5282/api/Maestro/Lista');
  final baseUr2 = Uri.parse('http://10.0.2.2:5282/api/Maestro/Guardar');
  final baseUr3 = Uri.parse('http://10.0.2.2:5282/api/Maestro/Editar');
  final baseUr4 = Uri.parse('http://10.0.2.2:5282/api/Maestro/Eliminar');

  Future<List<Maestro>> getMaestro() async {
    final response = await http.get(baseUrl);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final maestroResponse = MaestroResponse.fromJson(jsonData);

      if (maestroResponse.respuesta != null) {
        return maestroResponse.respuesta!;
      } else {
        throw Exception('No se encontraron datos de los maestros');
      }
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future<bool> postMaestro({required Maestro maestro}) async {
    try {
      final response = await http.post(
        (baseUr2),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(maestro.toJson()),
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

  Future<bool> putMaestro({required Maestro maestro}) async {
    print(maestro.idMaestro);
    try {
      final response = await http.put(baseUr3,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          "idMaestro": maestro.idMaestro,
          "nombre": maestro.nombre,
          "apellido": maestro.apellido,
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

  Future<bool> deleteMaestro({required int idMaestro}) async {
    try {
      final response = await http.delete(Uri.parse('$baseUr4/$idMaestro'));
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
