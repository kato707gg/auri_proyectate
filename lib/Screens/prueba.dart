import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class Sidebar1 extends StatelessWidget {
  const Sidebar1({super.key});

  @override
  Widget build(BuildContext context) {
    return SliderDrawer(
      key: key,
      slider: Container(
        width: MediaQuery.of(context).size.width * 0.6, // Ancho del menú
        color: Colors.red,
      ),
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Opción 1'),
              onTap: () {
                // Acción al seleccionar la opción 1
              },
            ),
            ListTile(
              title: Text('Opción 2'),
              onTap: () {
                // Acción al seleccionar la opción 2
              },
            ),
            // Agrega más opciones según sea necesario
          ],
        ),
      ),
    );
  }
}
