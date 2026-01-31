import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

class CameraService {
  static final ImagePicker _picker = ImagePicker();

  // Take photo from camera and convert to JPG
  static Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo == null) return null;
      return await _convertToJpg(File(photo.path));
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  // Pick image from gallery and convert to JPG
  static Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;
      return await _convertToJpg(File(image.path));
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Convert image to JPG format
  static Future<File> _convertToJpg(File imageFile) async {
    try {
      // Read the image
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) return imageFile;
      
      // Encode as JPG
      final jpg = img.encodeJpg(image, quality: 85);
      
      // Save to temp directory with .jpg extension
      final tempDir = await getTemporaryDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final jpgFile = File(path.join(tempDir.path, fileName));
      
      await jpgFile.writeAsBytes(jpg);
      return jpgFile;
    } catch (e) {
      print('Error converting to JPG: $e');
      return imageFile;
    }
  }
}