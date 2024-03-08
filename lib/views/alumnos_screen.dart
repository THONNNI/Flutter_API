import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/alumnos_model.dart';
import 'package:flutter_application_3/services/alumnos_services.dart';

class AlumnosScreen extends StatefulWidget {
  @override
  _AlumnosScreenState createState() => _AlumnosScreenState();
}

class _AlumnosScreenState extends State<AlumnosScreen> {
  final AlumnosService alumnosService = AlumnosService();
  List<Alumno> alumnosList = [];

  final _formKey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController idGrupoController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController celularController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerAlumnos();
  }

  Future<void> obtenerAlumnos() async {
    List<Alumno> alumnos = await alumnosService.getAlumnos();
    setState(() {
      alumnosList = alumnos;
    });
  }

  void limpiarCampos() {
    idController.clear();
    nombreController.clear();
    apellidoController.clear();
    idGrupoController.clear();
    correoController.clear();
    celularController.clear();
  }

  Future<void> mostrarDialogoEditar(Alumno alumno) async {
    idController.text = alumno.id.toString();
    nombreController.text = alumno.nombre;
    apellidoController.text = alumno.apellido;
    idGrupoController.text = alumno.idGrupo.toString();
    correoController.text = alumno.correo;
    celularController.text = alumno.celular.toString();

    bool camposValidos = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Alumno'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  camposValidos = true;
                  Navigator.of(context).pop();
                }
              },
              child: Text('Guardar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (camposValidos) {
      actualizarAlumno(alumno.id!);
    }

    setState(() {
      idController.clear();
      nombreController.clear();
      apellidoController.clear();
      idGrupoController.clear();
      correoController.clear();
      celularController.clear();
    });
  }

  Future<void> eliminarAlumnoDialogo(int id) async {
    bool confirmacion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de eliminar este alumno?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmacion) {
      eliminarAlumno(id);
    }
  }

  Future<void> agregarAlumno() async {
    if (_formKey.currentState!.validate()) {
      String _nombre = nombreController.text;
      String _apellido = apellidoController.text;
      int _idGrupo = int.tryParse(idGrupoController.text) ?? 0;
      String _correo = correoController.text;
      int _celular = int.tryParse(celularController.text) ?? 0;

      Alumno nuevoAlumno = Alumno(
        nombre: _nombre,
        apellido: _apellido,
        idGrupo: _idGrupo,
        correo: _correo,
        celular: _celular,
      );

      if (await alumnosService.postAlumnos(alumno: nuevoAlumno)) {
        print("Se agregó");
      } else {
        print("Nada chavo");
      }

      await obtenerAlumnos();
      limpiarCampos();
    }
  }

  Future<void> actualizarAlumno(int id) async {
    if (_formKey.currentState!.validate()) {
      String nombre = nombreController.text;
      String apellido = apellidoController.text;
      int idGrupo = int.tryParse(idGrupoController.text) ?? 0;
      String correo = correoController.text;
      int celular = int.tryParse(celularController.text) ?? 0;

      Alumno alumnoActualizado = Alumno(
        id: id,
        nombre: nombre,
        apellido: apellido,
        idGrupo: idGrupo,
        correo: correo,
        celular: celular,
      );

      if (await alumnosService.putAlumnos(alumno: alumnoActualizado)) {
        print("esta vivooo");
      } else {
        print("ta tieso");
      }

      await obtenerAlumnos();
      limpiarCampos();
    }
  }

  void eliminarAlumno(int id) async {
    await alumnosService.deleteAlumnos(id: id);
    await obtenerAlumnos();
    limpiarCampos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Alumnos'),
        backgroundColor: Color(0xFF28E7C5),
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<List<Alumno>>( //FUTUREBUILDER
        future: alumnosService.getAlumnos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<Alumno> alumnosList = snapshot.data ?? [];
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Agregar Alumno'),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
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
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        agregarAlumno();
                        Navigator.of(context).pop();
                      } else {}
                    },
                    child: Text('Agregar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      limpiarCampos();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF28E7C5), // Color verde marino
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/alumnos');
              break;
            case 1:
              Navigator.pushNamed(context, '/grupos');
              break;
            case 2:
              Navigator.pushNamed(context, '/maestros');
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Alumnos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Grupos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Maestros',
          ),
        ],
        backgroundColor: Color(0xFF28E7C5), // Color verde marino
        selectedItemColor:
            Colors.white, //Iconos seleccionados
      ),
    );
  }
}
