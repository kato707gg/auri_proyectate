import 'dart:io';

import 'package:flutter/material.dart';

class EditPhotoScreen extends StatelessWidget {
  final String imagePath;

  const EditPhotoScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Foto'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
