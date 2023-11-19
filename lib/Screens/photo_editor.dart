import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class PhotoEditor extends StatefulWidget {
  @override
  _PhotoEditorState createState() => _PhotoEditorState();
}

class _PhotoEditorState extends State<PhotoEditor> {
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
        _isHoldingImage = false;
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
        _isHoldingImage = true;
      });

      print('Transformed Image URL: $_transformedImageUrl');
    } on CloudinaryException catch (e) {
      print('Cloudinary Exception: ${e.message}');
      print('Request Details: ${e.request}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Editor'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onLongPress: () {
              setState(() {
                _isHoldingImage = true;
              });
            },
            onLongPressUp: () {
              setState(() {
                _isHoldingImage = false;
              });
            },
            child: Stack(
              children: [
                Visibility(
                  visible: _isHoldingImage && _transformedImageUrl != null,
                  child: Image.network(
                    _transformedImageUrl!,
                    key: _key,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Visibility(
                  visible: !_isHoldingImage,
                  child: Image.file(
                    _selectedImage!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
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
        ],
      ),
    );
  }
}
