import 'dart:async';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ModificarObjetos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
  Reemplazar,
  Remover,
  //Recolorear,
}

AdjustType _selectedAdjustment = AdjustType.Reemplazar;

class _HomeBodyState extends State<HomeBody> {
  File? _selectedImage;
  String _from = '';
  String _to = '';
  String _prompt = '';
  String _recolor = '';
  String? _transformedImageUrl;
  UniqueKey _key = UniqueKey();
  bool _isHoldingImage = false;
  bool _imageSelected = false;

  // Mapa para almacenar las transformaciones por tipo de ajuste
  Map<AdjustType, String?> _transformations = {};

  // Método para obtener la transformación actual para el tipo de ajuste dado
  String? _getCurrentTransformation() {
    return _transformations[_selectedAdjustment];
  }

  // Método para actualizar la transformación actual para el tipo de ajuste dado
  void _updateCurrentTransformation(String? transformedImageUrl) {
    _transformations[_selectedAdjustment] = transformedImageUrl;
    setState(() {
      _transformedImageUrl = transformedImageUrl;
      _key = UniqueKey();
    });
  }

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'dq4nxmjmd',
    'auriproyectate',
  );

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
      final publicId = cloudinaryResponse.publicId;
      final transform = _cloudinary.getImage(publicId).transform();

      if (_selectedAdjustment == AdjustType.Reemplazar) {
        transform.effect('gen_replace:from_$_from;to_$_to');
      } else if (_selectedAdjustment == AdjustType.Remover) {
        transform.effect('gen_remove:prompt_$_prompt');
      } else {
        transform.effect('gen_recolor:prompt_$_prompt');
      }

      final transformedImageUrl = transform.generate();

      // Actualizar la transformación actual para el tipo de ajuste seleccionado
      _updateCurrentTransformation(transformedImageUrl);

      setState(() {
        _transformedImageUrl = transformedImageUrl;
        _key = UniqueKey();
      });

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
        Title(),
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
              margin: EdgeInsets.all(30),
              width: double.infinity,
              decoration: BoxDecoration(
                color: _imageSelected
                    ? Colors.transparent
                    : Color.fromARGB(55, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Visibility(
                    visible: !_isHoldingImage && _transformedImageUrl != null,
                    child: _transformedImageUrl != null &&
                            Uri.parse(_transformedImageUrl!).isAbsolute
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
        ModifyButtonTable(
          onModifySelected: (adjustType) {
            setState(() {
              _selectedAdjustment = adjustType;
            });
          },
        ),
        if (_selectedAdjustment == AdjustType.Reemplazar) ...[
          PromptInput(
            key: UniqueKey(), // Asegúrate de tener una clave única
            onChanged: (value) {
              _from = value;
            },
            label: 'Objeto que se reemplazará',
            icon: Icons.check,
          ),
          PromptInput(
            key: UniqueKey(), // Otra clave única para el segundo PromptInput
            onChanged: (value) {
              _to = value;
            },
            onSubmitted: _updateImage,
            label: 'Objeto que será reemplazado',
            icon: Icons.near_me,
          ),
        ] else ...[
          PromptInput(
            onChanged: (value) {
              _prompt = value;
            },
            onSubmitted: _updateImage,
            label: 'Objeto a modificar',
            icon: Icons.near_me,
          ),
        ],
      ],
    );
  }
}

String getLabelForAdjustType(AdjustType adjustType) {
  switch (adjustType) {
    case AdjustType.Reemplazar:
      return 'Reemplzar';
    case AdjustType.Remover:
      return 'Remover';
    /*case AdjustType.Recolorear:
      return 'Recolorear';*/
  }
}

AssetImage getImageForAdjustType(AdjustType adjustType) {
  switch (adjustType) {
    case AdjustType.Reemplazar:
      return AssetImage('assets/reemplazar.png');
    case AdjustType.Remover:
      return AssetImage('assets/goma.png');
    /*case AdjustType.Recolorear:
      return AssetImage('assets/brocha.png');*/
  }
}

class ModifyButtonTable extends StatelessWidget {
  final Function(AdjustType) onModifySelected;

  ModifyButtonTable({
    Key? key,
    required this.onModifySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: AdjustType.values.map((adjustType) {
          return Expanded(
            child: ModifyButton(
              imagen: getImageForAdjustType(adjustType),
              texto1: getLabelForAdjustType(adjustType),
              onModifySelected: (type) {
                onModifySelected(type);
              },
              modifyType: adjustType,
              isSelected: _selectedAdjustment == adjustType,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ModifyButton extends StatefulWidget {
  final AssetImage imagen;
  final String texto1;
  final Function(AdjustType) onModifySelected;
  final AdjustType modifyType;
  final bool isSelected;

  const ModifyButton({
    Key? key,
    required this.imagen,
    required this.texto1,
    required this.onModifySelected,
    required this.modifyType,
    required this.isSelected,
  }) : super(key: key);

  @override
  _ModifyButtonState createState() => _ModifyButtonState();
}

class _ModifyButtonState extends State<ModifyButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            widget.onModifySelected(widget.modifyType);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isSelected
                ? Color.fromARGB(255, 211, 204, 255)
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
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class PromptInput extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final IconData? icon;
  final VoidCallback? onSubmitted;

  PromptInput({
    Key? key,
    required this.onChanged,
    required this.label,
    this.icon,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: label,
              suffixIconColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(icon),
                onPressed:
                    onSubmitted, // Llama a la función cuando se presiona el ícono
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.7,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              labelStyle: GoogleFonts.poppins(
                color: Color.fromARGB(185, 221, 221, 221),
              ),
            ),
            onChanged: onChanged,
            onFieldSubmitted: (value) {
              if (onSubmitted != null) {
                onSubmitted!();
              }
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
