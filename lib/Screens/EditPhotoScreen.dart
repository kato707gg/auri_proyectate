import 'dart:convert';
import 'dart:io';
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
    var headers = {'Authorization': 'Client-ID $clientId'};

    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..files.add(http.MultipartFile.fromBytes('image', bytes, filename: 'image'));

    try {
      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var link = responseData['data']['link'];
        print("Enlace de la imagen: $link");
        return link;
      } else {
        print("Error al subir la imagen. Código de estado: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Error durante la solicitud: $e");
    }
    return null; // Retorna null en caso de error
  }

  Future<String?> makePredictionRequestAndGetImageUrl() async {
    var imageUri = await subirImagen();
    print("Entro a convertir");

    final String apiUrl = "https://api.replicate.com/v1/predictions";
    final String authToken = "Token r8_cbAmgoyJPEbI8rQ4EcUorwso9yArZwY41ixtM";

    try {
      final response = await http.post(
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
        body: jsonEncode({
          "version": "ae80bbe1adce7d616b8a96ba88a91d3556838d4f2f4da76327638b8e95ea4694",
          "input": {
            "img": imageUri,
            "scale": 2,
            "version": "v1.3"
          }
        }),
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var predictionId = responseData['id'];
        print("ID del resultado: $predictionId");

        // Genera la apiUrl para obtener la imagen modificada
        var modifiedImageUrl = "https://api.replicate.com/v1/predictions/$predictionId";
        print("API URL para la imagen modificada: $modifiedImageUrl");

        return modifiedImageUrl;
      } else {
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
          await Future.delayed(Duration(seconds: 5));
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
      print("Verificando el estado de la predicción en $predictionStatusUrl");

      while (true) {
        try {
          var response = await http.get(Uri.parse(predictionStatusUrl));

          if (response.statusCode == 200) {
            var statusResponse = json.decode(response.body);
            var predictionStatus = statusResponse['status'];

            if (predictionStatus == 'succeeded') {
              var modifiedImageUrl = statusResponse['urls']['result'];
              print("La predicción ha tenido éxito. Enlace de la imagen modificada: $modifiedImageUrl");
              break;
            } else if (predictionStatus == 'failed') {
              print("La predicción ha fallado. Revisa los logs para más detalles.");
              break;
            } else {
              print("La predicción está en proceso. Esperando...");
              await Future.delayed(Duration(seconds: 5)); // Espera 5 segundos antes de volver a verificar
            }
          } else {
            print("Error al verificar el estado de la predicción. Código de estado: ${response.statusCode}");
            print(response.body);
            break;
          }
        } catch (e) {
          print("Error durante la solicitud de verificación del estado de la predicción: $e");
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
