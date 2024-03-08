class Maestro {
  final int idMaestro;
  final String nombre;
  final String apellido;

  Maestro({
    required this.idMaestro,
    required this.nombre,
    required this.apellido,
  });

  factory Maestro.fromJson(Map<String, dynamic> json) {
    return Maestro(
      idMaestro: json['idMaestro'],
      nombre: json['nombre'], 
      apellido: json['apellido'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'idMaestro': idMaestro,
      'nombre': nombre,
      'apellido': apellido,
    };
  }
}

class MaestroResponse {
  String? mensaje;
  List<Maestro>? respuesta;

  MaestroResponse({
    this.mensaje,
    this.respuesta,
  });

  factory MaestroResponse.fromJson(Map<String, dynamic> json) {
    return MaestroResponse(
      mensaje: json['mensaje'],
      respuesta: (json['response'] as List<dynamic>?)
          ?.map((maestroJson) => Maestro.fromJson(maestroJson))
          .toList(),
    );
  }
}
