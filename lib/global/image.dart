import 'dart:io';
import 'dart:typed_data';

/*
Creating a singleton instance, used for storing an image when creating your profile
 */
class ImageStore {
  static Uint8List? image;
  static File? selectedImage;
}