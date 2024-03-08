class Alumno {
  final int? id;
  final String nombre;
  final String apellido;
  final int idGrupo;
  final String correo;
  final int celular;

  Alumno({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.idGrupo,
    required this.correo,
    required this.celular,
  });

  factory Alumno.fromJson(Map<String, dynamic> json) {
    return Alumno(
      id: json['id'],
      idGrupo: json['idGrupo'], 
      nombre: json['nombre'],
      apellido: json['apellido'],
      correo: json['correo'],
      celular: json['celular'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'idGrupo': idGrupo,
      'correo': correo,
      'celular': celular,
    };
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
