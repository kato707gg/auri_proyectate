import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auri_proyectate/Components/sidebar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'EditPhotoScreen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackGround(),
          Homebody(),
        ],
      ),
      drawer: Sidebar(
        isActive: false,
      ),
    );
  }
}

class BackGround extends StatelessWidget {
  const BackGround({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 1.0],
          colors: [
            Color.fromARGB(255, 218, 219, 255),
            Color.fromARGB(255, 255, 255, 255),
          ],
        ),
      ),
    );
  }
}

class Homebody extends StatelessWidget {
  const Homebody({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          TitleWithButton(),
          SubTitle(),
          InvestmentTable(),
        ],
      ),
    );
  }
}

class TitleWithButton extends StatelessWidget {
  const TitleWithButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SidebarButton(),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Title(),
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarButton extends StatelessWidget {
  const SidebarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 11),
      child: ElevatedButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
          elevation: 5,
        ),
        child: const Icon(
          Icons.menu,
          color: Color.fromARGB(255, 56, 56, 56),
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 20),
      child: Text(
        'Desbloquea el poder del la IA',
        style: GoogleFonts.quicksand(
          fontSize: 35,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        maxLines: 2,
        textAlign: TextAlign.end,
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  const SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        Align(
          alignment: Alignment
              .topCenter, // Alinea el segundo elemento en la parte superior derecha
          child: Text(
            'Obten las mejores fotos y',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 85, 85, 85)),
          ),
        ),
        Align(
          alignment: Alignment
              .topCenter, // Alinea el segundo elemento en la parte superior derecha
          child: Text(
            'aumenta tu productividad',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 85, 85, 85)),
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}

class InvestmentTable extends StatelessWidget {
  const InvestmentTable({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyInvestmentsCard(
            imagen: 'assets/photo_edit.jpg',
            texto1: 'Editar fotos',
          ),
          MyInvestmentsCard(
            imagen: 'assets/noche_estrellada.jpg',
            texto1: 'Estilo Artístico',
          ),
          MyInvestmentsCard(
            imagen: 'assets/foto_antigua.jpg',
            texto1: 'Recuerdos\ndel Pasado',
          ),
          MyInvestmentsCard(
            imagen: 'assets/personajes_en_fotos.jpg',
            texto1: 'Personajes\nen tus fotos',
          ),
        ],
      ),
    );
  }
}

class MyInvestmentsCard extends StatelessWidget {
  final String imagen;
  final String texto1;

  const MyInvestmentsCard({
    Key? key,
    required this.imagen,
    required this.texto1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('Clic en $texto1');

        final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          print('Imagen seleccionada: ${pickedFile.path}');

          // Navegar a la pantalla de edición con la imagen seleccionada
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPhotoScreen(imagePath: pickedFile.path),
            ),
          );
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(imagen),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              height: 130,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Color.fromARGB(0, 143, 143, 143).withOpacity(0.1),
                    Color.fromARGB(255, 59, 59, 59).withOpacity(0.4),
                    Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      texto1,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
