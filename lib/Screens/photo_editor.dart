import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 204, 246, 255),
            Color.fromARGB(255, 25, 36, 37),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                opticalSize: 30,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Editar fotos',
              style: GoogleFonts.quicksand(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  File? _selectedImage;
  double _brightnessValue = 0.0;
  double _contrastValue = 0.0;
  String? _transformedImageUrl;
  UniqueKey _key = UniqueKey();
  bool _isHoldingImage = false;

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'dq4nxmjmd',
    'auriproyectate',
  );

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _transformedImageUrl = null;
        _key = UniqueKey();
      });
    }
  }

  Future<void> _uploadAndTransformImage() async {
    if (_selectedImage == null) {
      return;
    }

    try {
      final cloudinaryFile = CloudinaryFile.fromFile(
        _selectedImage!.path,
        folder: 'public',
      );

      final cloudinaryResponse = await _cloudinary.uploadFile(cloudinaryFile);

      final transformedImageUrl = _cloudinary
          .getImage(cloudinaryResponse.publicId)
          .transform()
          .effect('brightness:${_brightnessValue.round()}')
          .chain()
          .effect('brightness:${_contrastValue.round()}')
          .generate();

      setState(() {
        _transformedImageUrl = transformedImageUrl;
        _key = UniqueKey();
      });

      print('Transformed Image URL: $_transformedImageUrl');
    } on CloudinaryException catch (e) {
      print('Cloudinary Exception: ${e.message}');
      print('Request Details: ${e.request}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          onTapDown: (_) {
            setState(() {
              _isHoldingImage = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              _isHoldingImage = false;
            });
          },
          child: Stack(
            children: [
              Visibility(
                visible: !_isHoldingImage && _transformedImageUrl != null,
                child: _transformedImageUrl != null
                    ? Image.network(
                        _transformedImageUrl!,
                        key: _key,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(),
              ),
              Visibility(
                visible: _isHoldingImage || _transformedImageUrl == null,
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        key: _key,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Pick Image'),
        ),
        Slider(
          value: _brightnessValue,
          min: -99.0,
          max: 100.0,
          onChanged: (value) {
            setState(() {
              _brightnessValue = value.toInt().toDouble();
            });
          },
          label: 'Brightness',
        ),
        Text(_brightnessValue.toInt().toString()),
        Slider(
          value: _contrastValue,
          min: -99.0,
          max: 100.0,
          onChanged: (value) {
            setState(() {
              _contrastValue = value.toInt().toDouble();
            });
          },
          label: 'Contrast',
        ),
        Text(_contrastValue.toInt().toString()),
        ElevatedButton(
          onPressed: _uploadAndTransformImage,
          child: Text('Upload and Transform Image'),
        ),
        RecomendedTable(),
      ],
    );
  }
}

class PhotoEditor extends StatelessWidget {
  const PhotoEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Title(),
          HomeBody(),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PhotoEditor(),
  ));
}

class RecomendedTable extends StatelessWidget {
  const RecomendedTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            RecomendedCard(
              imagen: AssetImage('assets/xbox.png'),
              texto1: ('Xbox'),
            ),
            RecomendedCard(
              imagen: AssetImage('assets/mcdonalds.png'),
              texto1: ('McDonalds'),
            ),
            RecomendedCard(
              imagen: AssetImage('assets/tiktok.png'),
              texto1: ('TikTok'),
            ),
            RecomendedCard(
              imagen: AssetImage('assets/google.png'),
              texto1: ('Google'),
            ),
            RecomendedCard(
              imagen: AssetImage('assets/hbo.png'),
              texto1: ('HBO'),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ));
  }
}

class RecomendedCard extends StatelessWidget {
  final AssetImage imagen;
  final String texto1;

  const RecomendedCard({super.key, required this.imagen, required this.texto1});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width:
                80.0, // Ajusta según sea necesario para el tamaño del círculo
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 61, 59, 62),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Image(
                image: imagen,
                width:
                    30.0, // Ajusta según sea necesario para el tamaño de la imagen
                height: 30.0,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            this.texto1,
            style: TextStyle(
              fontFamily: 'NunitoSans',
              fontSize: 15.0,
              //fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 154, 65),
            ),
          ),
        ],
      ),
    );
  }
}
