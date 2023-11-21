import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class PhotoEditor extends StatelessWidget {
  const PhotoEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          HomeBody(),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 204, 246, 255),
            Color.fromARGB(255, 11, 20, 20),
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

enum AdjustType {
  Brightness,
  Contrast,
  Saturation,
  Vibrance,
  Hue,
  Tint,
}

// Variable para almacenar el tipo de ajuste seleccionado
AdjustType _selectedAdjustment = AdjustType.Brightness;

class _HomeBodyState extends State<HomeBody> {
  File? _selectedImage;
  double _brightnessValue = 0.0;
  double _contrastValue = 0.0;
  double _saturationValue = 0.0;
  double _vibranceValue = 0.0;
  double _hueValue = 0.0;
  double _tintValue = 0.0;
  String? _transformedImageUrl;
  UniqueKey _key = UniqueKey();
  bool _isHoldingImage = false;
  bool _imageSelected = false;
  late Timer _debounce;

  _HomeBodyState() {
    _debounce = Timer(const Duration(milliseconds: 500), () {});
  }

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

  void _handleAutomaticAdjustment() {
    if (_selectedAdjustment != null) {
      _debounceAction(() {
        _uploadAndTransformImage(
            automatic: true, automaticType: _selectedAdjustment);
      });
    }
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

  void _uploadAndTransformImage(
      {bool automatic = false, AdjustType? automaticType}) async {
    if (_selectedImage == null) {
      return;
    }

    try {
      final cloudinaryFile = CloudinaryFile.fromFile(
        _selectedImage!.path,
        folder: 'public',
      );

      final cloudinaryResponse = await _cloudinary.uploadFile(cloudinaryFile);
      final publicId = cloudinaryResponse.publicId;

      final transform = _cloudinary.getImage(publicId).transform();

      if (automatic) {
        transform.effect('auto_${_getAutomaticEffect(automaticType)}');
      } else {
        transform
            .effect('brightness:${_brightnessValue.round()}')
            .chain()
            .effect('contrast:${_contrastValue.round()}')
            .chain()
            .effect('saturation:${_saturationValue.round()}')
            .chain()
            .effect('vibrance:${_vibranceValue.round()}')
            .chain()
            .effect('hue:${_hueValue.round()}')
            .chain()
            .effect('green:${_tintValue.round()}');
      }

      final transformedImageUrl = transform.generate();

      setState(() {
        _transformedImageUrl = transformedImageUrl;
        _key = UniqueKey();
      });

      print('Transformed Image URL: $_transformedImageUrl');
    } catch (e) {
      print('Error during image transformation: $e');
    }
  }

  String _getAutomaticEffect(AdjustType? automaticType) {
    switch (automaticType) {
      case AdjustType.Brightness:
        return 'brightness';
      case AdjustType.Contrast:
        return 'contrast';
      case AdjustType.Saturation:
        return 'saturation';
      default:
        return '';
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
                  // Cambiar el tipo de ajuste seleccionado
                  setState(() {
                    _selectedAdjustment = adjustType;
                  });
                },
              ),
            ),
            // Mostrar la barra deslizante según el tipo de ajuste seleccionado
            if (_selectedAdjustment == AdjustType.Brightness ||
                _selectedAdjustment == AdjustType.Contrast ||
                _selectedAdjustment == AdjustType.Saturation ||
                _selectedAdjustment == AdjustType.Vibrance ||
                _selectedAdjustment == AdjustType.Hue ||
                _selectedAdjustment == AdjustType.Tint)
              SingleSlider(
                value: _selectedAdjustment == AdjustType.Brightness
                    ? _brightnessValue
                    : _selectedAdjustment == AdjustType.Contrast
                        ? _contrastValue
                        : _selectedAdjustment == AdjustType.Saturation
                            ? _saturationValue
                            : _selectedAdjustment == AdjustType.Vibrance
                                ? _vibranceValue
                                : _selectedAdjustment == AdjustType.Hue
                                    ? _hueValue
                                    : _tintValue,
                onChanged: (value) {
                  setState(() {
                    if (_selectedAdjustment == AdjustType.Brightness) {
                      _brightnessValue = value;
                    } else if (_selectedAdjustment == AdjustType.Contrast) {
                      _contrastValue = value;
                    } else if (_selectedAdjustment == AdjustType.Saturation) {
                      _saturationValue = value;
                    } else if (_selectedAdjustment == AdjustType.Vibrance) {
                      _vibranceValue = value;
                    } else if (_selectedAdjustment == AdjustType.Hue) {
                      _hueValue = value;
                    } else if (_selectedAdjustment == AdjustType.Tint) {
                      _tintValue = value;
                    }
                  });

                  _debounceAction(() {
                    _updateImage();
                  });
                },
                label: _selectedAdjustment == AdjustType.Brightness
                    ? 'Brightness'
                    : _selectedAdjustment == AdjustType.Contrast
                        ? 'Contrast'
                        : _selectedAdjustment == AdjustType.Saturation
                            ? 'Saturation'
                            : _selectedAdjustment == AdjustType.Vibrance
                                ? 'Vibrance'
                                : _selectedAdjustment == AdjustType.Hue
                                    ? 'Hue'
                                    : 'Tint',
                onAutomaticPressed:
                    _handleAutomaticAdjustment, // Pass the callback function
                automaticType:
                    _selectedAdjustment, // Pass the callback function
              ),
          ],
        ),
      ],
    );
  }
}

class SingleSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final String label;
  final VoidCallback? onAutomaticPressed;
  final AdjustType? automaticType; // Nuevo parámetro

  const SingleSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.onAutomaticPressed,
    this.automaticType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: 10.0), // Ajusta el valor según sea necesario
          child: Slider(
            thumbColor: Color.fromARGB(255, 201, 201, 201),
            activeColor: Color.fromARGB(255, 255, 255, 255),
            inactiveColor: Color.fromARGB(255, 170, 193, 216),
            value: value,
            min: -99.0,
            max: 100.0,
            onChanged: (newValue) {
              onChanged(newValue);
              _HomeBodyState()._uploadAndTransformImage();
            },
            label: label,
          ),
        ),
        Text(
          value.toInt().toString(),
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                onChanged(0.0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Text(
                'Reset',
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            if (_selectedAdjustment == AdjustType.Brightness ||
                _selectedAdjustment == AdjustType.Contrast ||
                _selectedAdjustment == AdjustType.Saturation)
              ElevatedButton(
                onPressed: () {
                  onAutomaticPressed?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Text(
                  'Automático',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}

class AdjustPhotoTable extends StatefulWidget {
  final Function(AdjustType) onAdjustSelected;

  AdjustPhotoTable({
    Key? key,
    required this.onAdjustSelected,
  }) : super(key: key);

  @override
  _AdjustPhotoTableState createState() => _AdjustPhotoTableState();
}

class _AdjustPhotoTableState extends State<AdjustPhotoTable> {
  ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Añade un pequeño espacio (padding) al principio y al final de la lista de botones
    List<Widget> adjustedChildren = [
      SizedBox(width: MediaQuery.of(context).size.width / 2.75),
      ...AdjustType.values.map((adjustType) {
        return AdjustPhoto(
          imagen: getImageForAdjustType(adjustType),
          texto1: getLabelForAdjustType(adjustType),
          onAdjustSelected: (type) {
            widget.onAdjustSelected(type);
            scrollToSelected(adjustType);
          },
          adjustmentType: adjustType,
          isSelected: _selectedAdjustment == adjustType,
        );
      }).toList(),
      SizedBox(
          width: MediaQuery.of(context).size.width / 2.7), // Padding al final
    ];

// Ancho de los botones

    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        children: adjustedChildren,
      ),
    );
  }

  void scrollToSelected(AdjustType adjustType) {
    setState(() {
      _selectedIndex = AdjustType.values.indexOf(adjustType);
    });

    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = 100;
    double offset = (_selectedIndex * itemWidth) +
        (screenWidth - itemWidth) / 2 - // Centrar al medio
        (screenWidth / 2) +
        (itemWidth / 2);

    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

String getLabelForAdjustType(AdjustType adjustType) {
  switch (adjustType) {
    case AdjustType.Brightness:
      return 'Brillo';
    case AdjustType.Contrast:
      return 'Contraste';
    case AdjustType.Saturation:
      return 'Saturación';
    case AdjustType.Vibrance:
      return 'Vividez';
    case AdjustType.Hue:
      return 'Matiz';
    case AdjustType.Tint:
      return 'Tono';
  }
}

AssetImage getImageForAdjustType(AdjustType adjustType) {
  switch (adjustType) {
    case AdjustType.Brightness:
      return AssetImage('assets/brillo.png');
    case AdjustType.Contrast:
      return AssetImage('assets/contraste.png');
    case AdjustType.Saturation:
      return AssetImage('assets/saturacion.png');
    case AdjustType.Vibrance:
      return AssetImage('assets/vibrance.png');
    case AdjustType.Hue:
      return AssetImage('assets/matiz2.png');
    case AdjustType.Tint:
      return AssetImage('assets/tono.png');
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
    return Container(
      margin: EdgeInsets.only(top: 0, left: 0, right: 0),
      width: 100.0,
      child: Column(
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
      ),
    );
  }
}
