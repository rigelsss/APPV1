// image_picker_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final XFile? image;
  final void Function(XFile?) onImagePicked;

  const ImagePickerWidget({
    super.key,
    required this.image,
    required this.onImagePicked,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    onImagePicked(pickedFile);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: image == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload, color: Colors.grey, size: 30),
                    SizedBox(height: 8),
                    Text('Clique para enviar', style: TextStyle(color: Colors.grey)),
                  ],
                )
              : Image.file(
                  File(image!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
      ),
    );
  }
}
