class Grupo {
  final int idGrupo;
  final String horario;
  final int idMaestro;
  final int numeroIntegrantes;


  Grupo({
    required this.idGrupo,
    required this.horario,
    required this.idMaestro,
    required this.numeroIntegrantes,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      idGrupo: json['idGrupo'],
      horario: json['horario'], 
      idMaestro: json['idMaestro'],
      numeroIntegrantes: json['numeroIntegrantes'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'idGrupo': idGrupo,
      'horario': horario,
      'idMaestro': idMaestro,
      'numeroIntegrantes': numeroIntegrantes,
    };
  }
}

class GrupoResponse {
  String? mensaje;
  List<Grupo>? respuesta;

  GrupoResponse({
    this.mensaje,
    this.respuesta,
  });

  factory GrupoResponse.fromJson(Map<String, dynamic> json) {
    return GrupoResponse(
      mensaje: json['mensaje'],
      respuesta: (json['response'] as List<dynamic>?)
          ?.map((grupoJson) => Grupo.fromJson(grupoJson))
          .toList(),
    );
  }
}
