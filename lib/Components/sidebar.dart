import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            left: 10.0, bottom: 10), // Ajusta la cantidad de despegue
        child: FractionallySizedBox(
          widthFactor: 0.6,
          child: Drawer(
            backgroundColor: Colors.transparent,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 2.5,
                  sigmaY: 2.5), // Ajusta el desenfoque según sea necesario
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: Color.fromARGB(255, 218, 240, 255),
                  child: ListView(
                    children: [
                      Container(
                        height: 200, // Ajusta la altura según sea necesario
                        child: DrawerHeader(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 218, 240, 255),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width:
                                    3.0, // Ajusta el ancho del borde según tus preferencias
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                  const AssetImage('assets/sigma.jpg'),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Mr.John',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 37, 37, 37),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'John300@gmail.com',
                                style: GoogleFonts.poppins(
                                  color: Color.fromARGB(255, 75, 75, 75),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          AnimatedPositioned(
                            height: 48, // Altura de la pantalla
                            width: isActive
                                ? MediaQuery.of(context).size.width * 0.6 - 6
                                : 0, // Ancho del 60% de la pantalla
                            duration: Duration(microseconds: 300),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 184, 223, 255),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.home),
                            title: Text('Home'),
                            onTap: () => onTap(context, 0),
                          ),
                        ],
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Profile'),
                        onTap: () => onTap(context, 0),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                        onTap: () => onTap(context, 0),
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                        onTap: () => onTap(context, 0),
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Logout'),
                        onTap: () => onTap(context, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

onTap(BuildContext context, int i) {}