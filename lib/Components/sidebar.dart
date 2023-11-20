import 'dart:ui';

<<<<<<< HEAD
import 'package:auri_proyectate/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int selectedIndex = -1;
=======
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.isActive});

  final bool isActive;
>>>>>>> 69ce224 (Can just select image NO edit)

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
<<<<<<< HEAD
        padding: EdgeInsets.only(left: 10.0, bottom: 10),
=======
        padding: EdgeInsets.only(
            left: 10.0, bottom: 10), // Ajusta la cantidad de despegue
>>>>>>> 69ce224 (Can just select image NO edit)
        child: FractionallySizedBox(
          widthFactor: 0.6,
          child: Drawer(
            backgroundColor: Colors.transparent,
            child: BackdropFilter(
              filter: ImageFilter.blur(
<<<<<<< HEAD
                sigmaX: 2.5,
                sigmaY: 2.5,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 0.5],
                      colors: [
                        Color.fromARGB(255, 222, 218, 255),
                        Color.fromARGB(255, 255, 255, 255),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 250,
                        child: DrawerHeader(
                          padding: EdgeInsets.symmetric(vertical: 10),
=======
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
>>>>>>> 69ce224 (Can just select image NO edit)
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
<<<<<<< HEAD
                                    width: 3.0,
=======
                                    width:
                                        3.0, // Ajusta el ancho del borde según tus preferencias
>>>>>>> 69ce224 (Can just select image NO edit)
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
<<<<<<< HEAD
                                'Diego H',
=======
                                'Mr.John',
>>>>>>> 69ce224 (Can just select image NO edit)
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
<<<<<<< HEAD
                                'DiegoH@gmail.com',
=======
                                'John300@gmail.com',
>>>>>>> 69ce224 (Can just select image NO edit)
                                style: GoogleFonts.poppins(
                                  color: Color.fromARGB(255, 75, 75, 75),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
<<<<<<< HEAD
                      SizedBox(
                        height: 20,
                      ),
                      buildListItem(Icons.person, 'Cuenta', 0),
                      SizedBox(
                        height: 10,
                      ),
                      buildListItem(Icons.settings, 'Settings', 1),
                      SizedBox(
                        height: 10,
                      ),
                      buildListItem(Icons.star_rounded, 'Novedades', 2),
                      SizedBox(
                        height: 10,
                      ),
                      buildListItem(Icons.question_mark_rounded, 'Ayuda', 3),
                      Spacer(),
                      SizedBox(
                        height: 20,
                      ),
                      buildListItem(Icons.exit_to_app_rounded, 'Logout', 4),
                      SizedBox(
                        height: 20,
=======
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
>>>>>>> 69ce224 (Can just select image NO edit)
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
<<<<<<< HEAD

  Widget buildListItem(IconData icon, String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        onTap(context, index);
      },
      child: Stack(
        children: [
          if (selectedIndex == index)
            Positioned(
              height: 56,
              width: MediaQuery.of(context).size.width * 0.6 - 6,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 219, 216, 255),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ListTile(
            leading: Icon(icon),
            title: Text(title),
          ),
        ],
      ),
    );
  }

  void onTap(BuildContext context, int index) {
    if (index == 4) {
      // Si se selecciona "Logout", navega a la pantalla de inicio de sesión
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
}
=======
}

onTap(BuildContext context, int i) {}
>>>>>>> 69ce224 (Can just select image NO edit)
