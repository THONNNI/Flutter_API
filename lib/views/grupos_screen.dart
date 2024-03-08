import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/grupos_model.dart';
import 'package:flutter_application_3/services/grupos_services.dart';

class GruposScreen extends StatefulWidget {
  @override
  _GruposScreenState createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  final GruposService gruposService = GruposService();
  List<Grupo> gruposList = [];

  final _formKey = GlobalKey<FormState>();

  TextEditingController idGrupoController = TextEditingController();
  TextEditingController horarioController = TextEditingController();
  TextEditingController idMaestroController = TextEditingController();
  TextEditingController numeroIntegrantesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerGrupos();
  }

  Future<void> obtenerGrupos() async {
    List<Grupo> grupos = await gruposService.getGrupo();
    setState(() {
      gruposList = grupos;
    });
  }

  void limpiarCampos() {
    idGrupoController.clear();
    horarioController.clear();
    idMaestroController.clear();
    numeroIntegrantesController.clear();
  }

  Future<void> mostrarDialogoEditar(Grupo grupo) async {
    idGrupoController.text = grupo.idGrupo.toString();
    horarioController.text = grupo.horario;
    idMaestroController.text = grupo.idMaestro.toString();
    numeroIntegrantesController.text = grupo.numeroIntegrantes.toString();

    bool camposValidos = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Grupo'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                    controller: horarioController,
                    decoration: InputDecoration(labelText: 'Horario'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor completa este campo';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: idMaestroController,
                    decoration: InputDecoration(labelText: 'ID Maestro'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor completa este campo';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: numeroIntegrantesController,
                    decoration:
                        InputDecoration(labelText: 'Número Integrantes'),
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
      actualizarGrupo();
    }

    setState(() {
      idGrupoController.clear();
      horarioController.clear();
      idMaestroController.clear();
      numeroIntegrantesController.clear();
    });
  }

  Future<void> eliminarGrupoDialogo(int idGrupo) async {
    bool confirmacion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de eliminar este grupo?'),
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
      eliminarGrupo(idGrupo);
    }
  }

  Future<void> agregarGrupo() async {
    if (_formKey.currentState!.validate()) {
      int _idGrupo = int.tryParse(idGrupoController.text) ?? 0;
      String _horario = horarioController.text;
      int _idMaestro = int.tryParse(idMaestroController.text) ?? 0;
      int _numeroIntegrantes =
          int.tryParse(numeroIntegrantesController.text) ?? 0;

      Grupo nuevoGrupo = Grupo(
        idGrupo: _idGrupo,
        horario: _horario,
        idMaestro: _idMaestro,
        numeroIntegrantes: _numeroIntegrantes,
      );

      if (await gruposService.postGrupo(grupo: nuevoGrupo)) {
        print("Se agregó el grupo");
      } else {
        print("No se agregó el grupo");
      }

      await obtenerGrupos();
      limpiarCampos();
    }
  }

  Future<void> actualizarGrupo() async {
    int _idGrupo = int.tryParse(idGrupoController.text) ?? 0;
    String _horario = horarioController.text;
    int _idMaestro = int.tryParse(idMaestroController.text) ?? 0;
    int _numeroIntegrantes =
        int.tryParse(numeroIntegrantesController.text) ?? 0;

    if (_idGrupo == 0 ||
        _horario.isEmpty ||
        _idMaestro == 0 ||
        _numeroIntegrantes == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Campos Vacíos'),
            content: Text('Por favor completa todos los campos'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    Grupo grupoActualizado = Grupo(
      idGrupo: _idGrupo,
      horario: _horario,
      idMaestro: _idMaestro,
      numeroIntegrantes: _numeroIntegrantes,
    );

    if (await gruposService.putGrupo(grupo: grupoActualizado)) {
      print("Se actualizó el grupo");
    } else {
      print("No se actualizó el grupo");
    }

    await obtenerGrupos();
    limpiarCampos();
  }

  Future<void> eliminarGrupo(int idGrupo) async {
    if (await gruposService.deleteGrupo(idGrupo: idGrupo)) {
      print("Se eliminó el grupo");
    } else {
      print("No se eliminó el grupo");
    }

    await obtenerGrupos();
    limpiarCampos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Grupos'),
        backgroundColor: Color(0xFF28E7C5),
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<List<Grupo>>(
        future: gruposService.getGrupo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<Grupo> gruposList = snapshot.data ?? [];
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: ListView.builder(
                itemCount: gruposList.length,
                itemBuilder: (context, index) {
                  final Grupo grupo = gruposList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        'Grupo ${grupo.idGrupo}',
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
                            'Horario: ${grupo.horario}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Text(
                            'ID Maestro: ${grupo.idMaestro}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Text(
                            'Número Integrantes: ${grupo.numeroIntegrantes}',
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
                              mostrarDialogoEditar(grupo);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              eliminarGrupoDialogo(grupo.idGrupo);
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
                title: Text('Agregar Grupo'),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: idGrupoController,
                          decoration: InputDecoration(
                            labelText: 'ID Grupo',
                            // Validator aquí...
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor completa este campo';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: horarioController,
                          decoration: InputDecoration(
                            labelText: 'Horario',
                            // Validator aquí...
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor completa este campo';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: idMaestroController,
                          decoration: InputDecoration(
                            labelText: 'ID Maestro',
                            // Validator aquí...
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor completa este campo';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: numeroIntegrantesController,
                          decoration: InputDecoration(
                            labelText: 'Número Integrantes',
                            // Validator aquí...
                          ),
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await agregarGrupo();
                        Navigator.of(context).pop();
                      }
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
        currentIndex: 1, // Establece el índice seleccionado a 1 (Grupos)
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
        backgroundColor: Color(0xFF28E7C5), 
        selectedItemColor:
            Colors.white, 
      ),
    );
  }
}
