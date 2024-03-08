import 'package:flutter/material.dart';
import 'views/alumnos_screen.dart';
import 'views/maestros_screen.dart';
import 'views/grupos_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor:
            Color(0xFF28E7C5), // Definimos el color principal como #28E7C5
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF28E7C5), // Color de fondo de los botones
          ),
        ),
      ),
      home: MainMenu(),
      routes: {
        '/alumnos': (context) => AlumnosScreen(),
        '/maestros': (context) => MaestrosScreen(),
        '/grupos': (context) => GruposScreen(),
      },
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú Principal')),
      body: Stack(
        children: [
          // Fondo con degradado
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF28E7C5),
                  Color(0xFF035AA6)
                ], // Colores del degradado
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/alumnos');
                  },
                  icon: Icon(Icons.people), // Icono de personas para Alumnos
                  label: Text('Alumnos'),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/maestros');
                  },
                  icon: Icon(Icons.school), // Icono de escuela para Maestros
                  label: Text('Maestros'),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/grupos');
                  },
                  icon: Icon(Icons.group), // Icono de grupo para Grupos
                  label: Text('Grupos'),
                ),
              ],
            ),
          ),
          // Elementos decorativos en la parte inferior
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
