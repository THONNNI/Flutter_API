import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/alumnos_model.dart';

class AlumnosList extends StatelessWidget {
  final List<Alumno> alumnosList;
  final Function(Alumno) mostrarDialogoEditar;
  final Function(int) eliminarAlumnoDialogo;

  AlumnosList({
    required this.alumnosList,
    required this.mostrarDialogoEditar,
    required this.eliminarAlumnoDialogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: ListView.builder(
        itemCount: alumnosList.length,
        itemBuilder: (context, index) {
          final Alumno alumno = alumnosList[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                '${alumno.nombre} ${alumno.apellido}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${alumno.id}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Text(
                    'Correo: ${alumno.correo}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Text(
                    'Celular: ${alumno.celular}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      mostrarDialogoEditar(alumno);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      eliminarAlumnoDialogo(alumno.id!);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}