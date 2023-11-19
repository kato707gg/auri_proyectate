import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final CloudinaryPublic _cloudinary;

  CloudinaryService(this._cloudinary);

  Future<String> uploadImage(String imagePath) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePath),
      );
      return response.secureUrl;
    } catch (e) {
      // Manejo de errores
      print("Error uploading image: $e");
      rethrow;
    }
  }
}
