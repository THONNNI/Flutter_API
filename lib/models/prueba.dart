import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Alumno {
  final int id;
  final String nombre;
  final String apellido;
  final int idGrupo;
  final String correo;
  final int celular;

  Alumno({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.idGrupo,
    required this.correo,
    required this.celular,
  });

  factory Alumno.fromJson(Map<String, dynamic> json) {
    return Alumno(
      id: json['id'],
      idGrupo: json['idGrupo'], // Modifiqué el nombre de la clave para coincidir con el JSON recibido
      nombre: json['nombre'],
      apellido: json['apellido'],
      correo: json['correo'],
      celular: json['celular'],
    );
  }
}

class AlumnoResponse {
  String? mensaje;
  List<Alumno>? respuesta;

  AlumnoResponse({
    this.mensaje,
    this.respuesta,
  });

  factory AlumnoResponse.fromJson(Map<String, dynamic> json) {
    return AlumnoResponse(
      mensaje: json['mensaje'],
      respuesta: (json['response'] as List<dynamic>?)
          ?.map((alumnoJson) => Alumno.fromJson(alumnoJson))
          .toList(),
    );
  }
}
///////fin modelo///////////


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Alumno>> fetchData() async {
    final response = await http.get(Uri.parse('URL_DE_TU_API_AQUÍ'));
    
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
/////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de la API'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            fetchData().then((alumnos) {
              // Aquí puedes trabajar con la lista de alumnos recibida
              // Por ejemplo, imprimir los nombres en la consola
              alumnos.forEach((alumno) {
                print('${alumno.nombre} ${alumno.apellido}');
              });
            }).catchError((error) {
              print('Error al obtener los datos: $error');
            });
          },
          child: Text('Obtener datos'),
        ),
      ),
    );
  }
}
