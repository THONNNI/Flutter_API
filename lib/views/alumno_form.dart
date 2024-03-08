import 'package:flutter/material.dart';

class AlumnoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController idController;
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final TextEditingController idGrupoController;
  final TextEditingController correoController;
  final TextEditingController celularController;

  AlumnoForm({
    required this.formKey,
    required this.idController,
    required this.nombreController,
    required this.apellidoController,
    required this.idGrupoController,
    required this.correoController,
    required this.celularController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: idController,
            readOnly: true,
            decoration: InputDecoration(labelText: 'ID'),
          ),
          TextFormField(
            controller: nombreController,
            decoration: InputDecoration(labelText: 'Nombre'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor completa este campo';
              }
              return null;
            },
          ),
          TextFormField(
            controller: apellidoController,
            decoration: InputDecoration(labelText: 'Apellido'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor completa este campo';
              }
              return null;
            },
          ),
          TextFormField(
            controller: idGrupoController,
            decoration: InputDecoration(labelText: 'ID Grupo'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor completa este campo';
              }
              return null;
            },
          ),
          TextFormField(
            controller: correoController,
            decoration: InputDecoration(labelText: 'Correo'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor completa este campo';
              }
              return null;
            },
          ),
          TextFormField(
            controller: celularController,
            decoration: InputDecoration(labelText: 'Celular'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor completa este campo';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}