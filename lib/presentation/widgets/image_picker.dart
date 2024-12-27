import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_up/styles/my_colors.dart';

import '../../global/image.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  Uint8List? _image;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _image = ImageStore.image;
    selectedImage = ImageStore.selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _image != null
            ? CircleAvatar(radius: 100, backgroundImage: MemoryImage(_image!))
            : const CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
              ),
        Positioned(
            top: 150,
            left: 140,
            child: IconButton(
                onPressed: () {
                  showImagePickerOption(context);
                },
                icon: const Icon(Icons.add_a_photo)))
      ],
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: MyColors.primary.pink500,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null || !mounted) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
      ImageStore.image = _image;
      ImageStore.selectedImage = selectedImage;
    });
    Navigator.of(context).pop();
  }

  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null || !mounted) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
      ImageStore.image = _image;
      ImageStore.selectedImage = selectedImage;
    });
    Navigator.of(context).pop();
  }
}
