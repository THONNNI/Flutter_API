import 'dart:convert';
import 'package:flutter_application_3/models/alumnos_model.dart';
import 'package:http/http.dart' as http;

class AlumnosService {
  final baseUrl = Uri.parse('http://10.0.2.2:5282/api/Alumnos/Lista');
  final baseUr2 = Uri.parse('http://10.0.2.2:5282/api/Alumnos/Guardar');
  final baseUr3 = Uri.parse('http://10.0.2.2:5282/api/Alumnos/Editar');
  final baseUr4 = Uri.parse('http://10.0.2.2:5282/api/Alumnos/Eliminar');

  Future<List<Alumno>> getAlumnos() async {
    final response = await http.get(baseUrl);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final alumnoResponse = AlumnoResponse.fromJson(jsonData);

      if (alumnoResponse.respuesta != null) {
        return alumnoResponse.respuesta!;
      } else {
        throw Exception('No se encontraron datos de alumnos');
      }
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future<bool> postAlumnos({required Alumno alumno}) async {
    try {
      final response = await http.post(
        (baseUr2),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(alumno.toJson()),
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

  Future<bool> putAlumnos({required Alumno alumno}) async {
    print(alumno.id);
    try {
      final response = await http.put(baseUr3,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          "id": alumno.id,
          "nombre": alumno.nombre,
          "apellido": alumno.apellido,
          "idGrupo": alumno.idGrupo,
          "correo": alumno.correo,
          "celular": alumno.celular,
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

  Future<bool> deleteAlumnos({required int id}) async {
    try {
      final response = await http.delete(Uri.parse('$baseUr4/$id'));
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
