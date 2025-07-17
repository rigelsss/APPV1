import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadImagensWidget extends StatelessWidget {
  final List<XFile> imagens;
  final Future<void> Function() onAdicionar;

  const UploadImagensWidget({
    super.key,
    required this.imagens,
    required this.onAdicionar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdicionar,
      child: DottedBorder(
        color: const Color.fromARGB(255, 191, 191, 191),
        strokeWidth: 1.5,
        dashPattern: [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(6),
        child: Container(
          height: 120,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: imagens.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload_outlined, size: 32, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Clique para enviar', style: TextStyle(color: Colors.grey)),
                  ],
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagens.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(imagens[index].path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
