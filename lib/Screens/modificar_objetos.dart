import 'dart:async';
import 'dart:io';
import 'package:auri_proyectate/Screens/photo_editor.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ModificarObjetos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackGround(),
          HomeBody(),
        ],
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
          colors: [
            Color.fromARGB(255, 211, 204, 255),
            Color.fromARGB(255, 15, 11, 20),
          ],
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
        padding: const EdgeInsets.only(top: 0, left: 10, right: 30),
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
              'Modificar objetos',
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

enum AdjustType {
  Brightness,
  Contrast,
  Saturation,
}

// Variable para almacenar el tipo de ajuste seleccionado
AdjustType _selectedAdjustment = AdjustType.Brightness;

class _HomeBodyState extends State<HomeBody> {
  File? _selectedImage;
  String _from = '';
  String _to = '';
  String? _transformedImageUrl;
  UniqueKey _key = UniqueKey();
  bool _isHoldingImage = false;
  bool _imageSelected = false;
  late Timer _debounce;

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'dq4nxmjmd',
    'auriproyectate',
  );

  void _debounceAction(VoidCallback action) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1), action);
  }

  void _updateImage() {
    _uploadAndTransformImage();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _transformedImageUrl = null;
        _key = UniqueKey();
        _imageSelected = true;
      });
    }
  }

  Future<void> _uploadAndTransformImage() async {
    if (_selectedImage == null) {
      // Handle case where no image is selected
      return;
    }

    try {
      // Upload the image to Cloudinary
      final cloudinaryFile = CloudinaryFile.fromFile(
        _selectedImage!.path,
        folder: 'public',
      );

      final cloudinaryResponse = await _cloudinary.uploadFile(cloudinaryFile);

      // Transform the image with brightness and contrast adjustments
      final transformedImageUrl = _cloudinary
          .getImage(cloudinaryResponse.publicId)
          .transform()
          .effect('gen_replace:from_${_from}')
          .effect(';')
          .effect('to_:${_to}');

      // Now you can use transformedImageUrl to display the edited image
      print('Transformed Image URL: $transformedImageUrl');
    } on CloudinaryException catch (e) {
      // Handle Cloudinary API exceptions
      print('Cloudinary Exception: ${e.message}');
      print('Request Details: ${e.request}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Title(),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (!_imageSelected) {
                _pickImage();
              }
            },
            onTapDown: (_) {
              setState(
                () {
                  _isHoldingImage = true;
                },
              );
            },
            onTapUp: (_) {
              setState(
                () {
                  _isHoldingImage = false;
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: 30, top: 15, right: 30, bottom: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: _imageSelected
                      ? Colors.transparent
                      : Color.fromARGB(55, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Visibility(
                    visible: !_isHoldingImage && _transformedImageUrl != null,
                    child: _transformedImageUrl != null
                        ? Image.network(
                            _transformedImageUrl!,
                            key: _key,
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
                            fit: BoxFit.cover,
                          )
                        : SizedBox(),
                  ),
                  Visibility(
                    visible: !_imageSelected,
                    child: Text(
                      "Seleccionar Foto",
                      style: GoogleFonts.poppins(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: AdjustPhotoTable(
                onAdjustSelected: (adjustType) {
                  setState(() {
                    _selectedAdjustment = adjustType;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AdjustPhotoTable extends StatelessWidget {
  final Function(AdjustType) onAdjustSelected;

  AdjustPhotoTable({
    Key? key,
    required this.onAdjustSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: AdjustType.values.map((adjustType) {
          return Expanded(
            child: AdjustPhoto(
              imagen: getImageForAdjustType(adjustType),
              texto1: getLabelForAdjustType(adjustType),
              onAdjustSelected: (type) {
                onAdjustSelected(type);
              },
              adjustmentType: adjustType,
              isSelected: _selectedAdjustment == adjustType,
            ),
          );
        }).toList(),
      ),
    );
  }
}

String getLabelForAdjustType(AdjustType adjustType) {
  switch (adjustType) {
    case AdjustType.Brightness:
      return 'Reemplzar';
    case AdjustType.Contrast:
      return 'Remover';
    case AdjustType.Saturation:
      return 'Recolorear';
  }
}

AssetImage getImageForAdjustType(AdjustType adjustType) {
  switch (adjustType) {
    case AdjustType.Brightness:
      return AssetImage('assets/reemplazar.png');
    case AdjustType.Contrast:
      return AssetImage('assets/goma.png');
    case AdjustType.Saturation:
      return AssetImage('assets/brocha.png');
  }
}

class AdjustPhoto extends StatefulWidget {
  final AssetImage imagen;
  final String texto1;
  final Function(AdjustType) onAdjustSelected;
  final AdjustType adjustmentType;
  final bool isSelected;

  const AdjustPhoto({
    Key? key,
    required this.imagen,
    required this.texto1,
    required this.onAdjustSelected,
    required this.adjustmentType,
    required this.isSelected,
  }) : super(key: key);

  @override
  _AdjustPhotoState createState() => _AdjustPhotoState();
}

class _AdjustPhotoState extends State<AdjustPhoto> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            widget.onAdjustSelected(widget.adjustmentType);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isSelected
                ? Color.fromARGB(255, 192, 231, 255)
                : Color.fromARGB(255, 255, 255, 255),
            fixedSize: Size(0, 70),
            shape: CircleBorder(side: BorderSide.none),
          ),
          child: Image(
            image: widget.imagen,
            width: 30.0,
            height: 30.0,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          widget.texto1,
          style: GoogleFonts.poppins(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}
