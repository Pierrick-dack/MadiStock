import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

import 'package:madistock/constants/app_colors.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(String? imagePath) onImageSelected;

  const ImagePickerWidget({super.key, required this.onImageSelected, String? initialImagePath});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String? _imagePath;

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Compresser l'image
      final compressedFile = await _compressImage(File(pickedFile.path));

      if (compressedFile != null) {
        setState(() {
          _imagePath = compressedFile.path;
        });
        widget.onImageSelected(_imagePath);

        // Ferme automatiquement le BottomSheet après la sélection de l'image
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  // Fonction pour compresser l'image
  Future<File?> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      file.absolute.path + '_compressed.jpg', // Chemin de sortie pour l'image compressée
      quality: 50, // Qualité de compression (0 à 100)
    );

    if (result != null) {
      return File(result.path);
    } else {
      return null;
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(29),
                      color: ccaColor,
                    ),
                    height: 5,
                    width: 95,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Ajouter une image",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery, context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: whiteColor,
                      backgroundColor: ccaColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library_rounded),
                    label: const Text('Galerie'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera, context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: whiteColor,
                      backgroundColor: ccaColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: const Text('Caméra'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: CircleAvatar(
        radius: 80,
        backgroundColor: cca2Color,
        backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
        child: _imagePath == null
            ? const Icon(Icons.camera_enhance_rounded, size: 40, color: whiteColor)
            : null,
      ),
    );
  }
}