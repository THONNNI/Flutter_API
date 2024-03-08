import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/maestros_model.dart';
import 'package:flutter_application_3/services/maestro_services.dart';

class MaestrosScreen extends StatefulWidget {
  @override
  _MaestrosScreen createState() => _MaestrosScreen();
}

class _MaestrosScreen extends State<MaestrosScreen> {
  final MaestrosService maestrosService = MaestrosService();
  List<Maestro> maestrosList = [];

  final _formKey = GlobalKey<FormState>();

  TextEditingController idMaestroController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerMestro();
  }

  Future<void> obtenerMestro() async {
    List<Maestro> maestros = await maestrosService.getMaestro();
    setState(() {
      maestrosList = maestros;
    });
  }

  void limpiarCampos() {
    idMaestroController.clear();
    nombreController.clear();
    apellidoController.clear();
  }

  Future<void> mostrarDialogoEditar(Maestro maestro) async {
    idMaestroController.text = maestro.idMaestro.toString();
    nombreController.text = maestro.nombre;
    apellidoController.text = maestro.apellido;

    bool camposValidos = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Maestro'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
      actualizarMaestro();
    }

    setState(() {
      idMaestroController.clear();
      nombreController.clear();
      apellidoController.clear();
    });
  }

  Future<void> eliminarMaestroDialogo(int idMaestro) async {
    bool confirmacion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de eliminar este Maestro?'),
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
      eliminarMaestro(idMaestro);
    }
  }

  Future<void> agregarMaestro() async {
    if (_formKey.currentState!.validate()) {
      int _idMaestro = int.tryParse(idMaestroController.text) ?? 0;
      String _nombre = nombreController.text;
      String _apellido = apellidoController.text;

      Maestro nuevoMaestro = Maestro(
        idMaestro: _idMaestro,
        nombre: _nombre,
        apellido: _apellido,
      );

      if (await maestrosService.postMaestro(maestro: nuevoMaestro)) {
        print("Se agregó el maestro");
      } else {
        print("No se agregó el maestro");
      }

      await obtenerMestro();
      limpiarCampos();
    }
  }

  Future<void> actualizarMaestro() async {
    int _idMaestro = int.tryParse(idMaestroController.text) ?? 0;
    String _nombre = nombreController.text;
    String _apellido = apellidoController.text;

    if (_idMaestro == 0 || _nombre.isEmpty || _apellido.isEmpty) {
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

    Maestro maestroActualizado = Maestro(
      idMaestro: _idMaestro,
      nombre: _nombre,
      apellido: _apellido,
    );

    if (await maestrosService.putMaestro(maestro: maestroActualizado)) {
      print("Se actualizó el maestro");
    } else {
      print("No se actualizó el maestro");
    }

    await obtenerMestro();
    limpiarCampos();
  }

  Future<void> eliminarMaestro(int idMaestro) async {
    if (await maestrosService.deleteMaestro(idMaestro: idMaestro)) {
      print("Se eliminó el maestro");
    } else {
      print("No se eliminó el maestro");
    }

    await obtenerMestro();
    limpiarCampos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Maestros'),
        backgroundColor: Color(0xFF28E7C5),
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: FutureBuilder<List<Maestro>>(
          future: maestrosService.getMaestro(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              List<Maestro> maestrosList = snapshot.data ?? [];
              return ListView.builder(
                itemCount: maestrosList.length,
                itemBuilder: (context, index) {
                  final Maestro maestro = maestrosList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        'Maestro ${maestro.idMaestro}',
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
                            'Nombre: ${maestro.nombre}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Text(
                            'Apellido: ${maestro.apellido}',
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
                              mostrarDialogoEditar(maestro);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              eliminarMaestroDialogo(maestro.idMaestro);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Agregar Maestro'),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: idMaestroController,
                          decoration: InputDecoration(
                            labelText: 'ID Maestro',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor completa este campo';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor completa este campo';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: apellidoController,
                          decoration: InputDecoration(
                            labelText: 'Apellido',
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
                        await agregarMaestro();
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
        backgroundColor: Color(0xFF28E7C5),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
        selectedItemColor: Colors.white,
      ),
    );
  }
}
