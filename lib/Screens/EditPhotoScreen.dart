import 'dart:convert';
import 'dart:io';
<<<<<<< HEAD
import 'package:auri_proyectate/Components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditPhotoScreen extends StatelessWidget {
  const EditPhotoScreen({super.key});

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
            Color.fromARGB(255, 255, 233, 204),
            Color.fromARGB(255, 20, 15, 11),
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
              'Restaurar fotos',
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
  String? _imageUrl;
  UniqueKey _key = UniqueKey();
  bool _isHoldingImage = false;
  bool _imageSelected = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageUrl = null;
        _imageSelected = true;
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) {
      return null;
    }

    var clientId = '66f78c6d24dc3c9';
    var url = Uri.parse('https://api.imgur.com/3/image');
    var bytes = await _selectedImage!.readAsBytes();
=======
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPhotoScreen extends StatefulWidget {
  final String imagePath;

  const EditPhotoScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _EditPhotoScreenState createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {
  String imageUrl = '';

  Future<String?> subirImagen() async {
    var clientId = '66f78c6d24dc3c9';
    var url = Uri.parse('https://api.imgur.com/3/image');
    var file = File(widget.imagePath);
    var bytes = await file.readAsBytes();
>>>>>>> d37bca496308de9b8086d89e4f7bf16caff2accf
    var headers = {'Authorization': 'Client-ID $clientId'};

    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
<<<<<<< HEAD
      ..files
          .add(http.MultipartFile.fromBytes('image', bytes, filename: 'image'));
=======
      ..files.add(http.MultipartFile.fromBytes('image', bytes, filename: 'image'));
>>>>>>> d37bca496308de9b8086d89e4f7bf16caff2accf

    try {
      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var link = responseData['data']['link'];
        print("Enlace de la imagen: $link");
        return link;
      } else {
<<<<<<< HEAD
        print(
            "Error al subir la imagen. Código de estado: ${response.statusCode}");
=======
        print("Error al subir la imagen. Código de estado: ${response.statusCode}");
>>>>>>> d37bca496308de9b8086d89e4f7bf16caff2accf
        print(response.body);
      }
    } catch (e) {
      print("Error durante la solicitud: $e");
    }
<<<<<<< HEAD

    return null; // Retorna null en caso de error
  }

  Future<String?> _makePredictionAndGetImageUrl() async {
    var imageUri = await _uploadImage();

    if (imageUri == null) {
      return null;
    }
=======
    return null; // Retorna null en caso de error
  }

  Future<String?> makePredictionRequestAndGetImageUrl() async {
    var imageUri = await subirImagen();
    print("Entro a convertir");
>>>>>>> d37bca496308de9b8086d89e4f7bf16caff2accf

    final String apiUrl = "https://api.replicate.com/v1/predictions";
    final String authToken = "Token r8_cbAmgoyJPEbI8rQ4EcUorwso9yArZwY41ixtM";

    try {
      final response = await http.post(
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode({
<<<<<<< HEAD
          "version":
              "9283608cc6b7be6b65a8e44983db012355fde4132009bf99d976b2f0896856a3",
          "input": {"img": imageUri, "scale": 2, "version": "v1.3"}
=======
          "version": "9283608cc6b7be6b65a8e44983db012355fde4132009bf99d976b2f0896856a3",
          "input": {
            "img": imageUri,
            "scale": 2,
            "version": "v1.3"
          }
>>>>>>> d37bca496308de9b8086d89e4f7bf16caff2accf
        }),
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var predictionId = responseData['id'];
        print("ID del resultado: $predictionId");

        // Genera la apiUrl para obtener la imagen modificada
<<<<<<< HEAD
        var modifiedImageUrl =
            "https://api.replicate.com/v1/predictions/$predictionId";
=======
        var modifiedImageUrl = "https://api.replicate.com/v1/predictions/$predictionId";
>>>>>>> d37bca496308de9b8086d89e4f7bf16caff2accf
        print("API URL para la imagen modificada: $modifiedImageUrl");

        return modifiedImageUrl;
      } else {
<<<<<<< HEAD
        print(
            "Error durante la solicitud de predicción. Código de estado: ${response.statusCode}");
        print("BODY: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error durante la solicitud de predicción: $e");
      return null;
    }
  }

  Future<void> _checkPredictionStatusAndFetchImage() async {
    var predictionId = await _makePredictionAndGetImageUrl();

    if (predictionId != null) {
      var predictionStatusUrl =
          "https://api.replicate.com/v1/predictions/$predictionId";
=======
        print("Error durante la solicitud de predicción. Código de estado: ${response.statusCode}");
        print("BODY: ${response.body}");
        var responseData = json.decode(response.body);
        var getUrl = responseData['urls']['get'];
        var idResponse = responseData['id'];
        print("URL de get: $getUrl");
        print("ID de response: $idResponse");

        var replicateDeliveryUrl = 'https://replicate.delivery/$idResponse';
        print(replicateDeliveryUrl);

        var delivery = "https://api.replicate.com/v1/predictions/$idResponse";
        print(delivery);


        var apiUrl = 'https://api.replicate.com/v1/predictions/$idResponse';
        print("mamalon $apiUrl");

        try {
          await Future.delayed(Duration(seconds: 30));
          var response = await http.get(
            headers: {'Authorization': 'Token r8_cbAmgoyJPEbI8rQ4EcUorwso9yArZwY41ixtM',  "Content-Type": "application/json" },
            Uri.parse(apiUrl),
          );

          if (response.statusCode == 200) {
            var responseData = json.decode(response.body);
            // Puedes trabajar con los datos de la respuesta según tus necesidades
            print("Respuesta de Replicate: $responseData");
            var oro = responseData['output'];
            print(oro);

            setState(() {
              // Actualiza la URL de la imagen en el estado
              imageUrl = oro;
            });
          } else {
            print("Error al obtener la respuesta de Replicate. Código de estado: ${response.statusCode}");
            print(response.body);
          }
        } catch (e) {
          print("Error durante la solicitud a Replicate: $e");
        }

      }
    } catch (e) {
      print("Error durante la solicitud de predicción: $e");
    }

    return null; // Retorna null en caso de error
  }

  Future<void> checkPredictionStatusAndFetchImage() async {
    var predictionId = await makePredictionRequestAndGetImageUrl();
    if (predictionId != null) {
      var predictionStatusUrl = "https://api.replicate.com/v1/predictions/$predictionId";
>>>>>>> d37bca496308de9b8086d89e4f7bf16caff2accf
      print("Verificando el estado de la predicción en $predictionStatusUrl");

      while (true) {
        try {
          var response = await http.get(Uri.parse(predictionStatusUrl));

          if (response.statusCode == 200) {
            var statusResponse = json.decode(response.body);
            var predictionStatus = statusResponse['status'];

            if (predictionStatus == 'succeeded') {
              var modifiedImageUrl = statusResponse['urls']['result'];
<<<<<<< HEAD
              print(
                  "La predicción ha tenido éxito. Enlace de la imagen modificada: $modifiedImageUrl");

              setState(() {
                // Actualiza la URL de la imagen en el estado
                _imageUrl = modifiedImageUrl;
              });

              break;
            } else if (predictionStatus == 'failed') {
              print(
                  "La predicción ha fallado. Revisa los logs para más detalles.");
              break;
            } else {
              print("La predicción está en proceso. Esperando...");
              await Future.delayed(Duration(
                  seconds: 5)); // Espera 5 segundos antes de volver a verificar
            }
          } else {
            print(
                "Error al verificar el estado de la predicción. Código de estado: ${response.statusCode}");
=======
              print("La predicción ha tenido éxito. Enlace de la imagen modificada: $modifiedImageUrl");
              break;
            } else if (predictionStatus == 'failed') {
              print("La predicción ha fallado. Revisa los logs para más detalles.");
              break;
            } else {
              print("La predicción está en proceso. Esperando...");
              // await Future.delayed(Duration(seconds: 5)); // Espera 5 segundos antes de volver a verificar
            }
          } else {
            print("Error al verificar el estado de la predicción. Código de estado: ${response.statusCode}");
>>>>>>> d37bca496308de9b8086d89e4f7bf16caff2accf
            print(response.body);
            break;
          }
        } catch (e) {
<<<<<<< HEAD
          print(
              "Error durante la solicitud de verificación del estado de la predicción: $e");
=======
          print("Error durante la solicitud de verificación del estado de la predicción: $e");
>>>>>>> d37bca496308de9b8086d89e4f7bf16caff2accf
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
              margin: EdgeInsets.only(left: 30, top: 15, right: 30),
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
                    visible: !_isHoldingImage && _imageUrl != null,
                    child: _imageUrl != null
                        ? Image.network(
                            _imageUrl!,
                            key: _key,
                            fit: BoxFit.cover,
                          )
                        : SizedBox(),
                  ),
                  Visibility(
                    visible: _isHoldingImage || _imageUrl == null,
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              ButtonUtils.buildElevatedButton(
                  context: context,
                  label: 'Transformar',
                  onPressed: _checkPredictionStatusAndFetchImage,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  textColor: Colors.black),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ],
=======
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Foto'),
      ),
      body: Center(
        // Muestra la imagen original o la imagen modificada según la URL actual
        child: imageUrl.isEmpty ? Image.file(File(widget.imagePath)) : Image.network(imageUrl),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await checkPredictionStatusAndFetchImage();
        },
        tooltip: 'Make Prediction',
        child: Icon(Icons.send),
      ),
>>>>>>> d37bca496308de9b8086d89e4f7bf16caff2accf
    );
  }
}
