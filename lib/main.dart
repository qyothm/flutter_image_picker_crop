import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_picker/image_helper.dart';
import 'package:image_cropper/image_cropper.dart';

void main() {
  runApp(const ProfileScreen());
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker & Cropper',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Image Picker & Cropper')),
        body: const ProfileImage(initials: 'AQ'),
      ),
    );
  }
}

final imageHelper = ImageHelper();

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    Key? key,
    required this.initials,
  }) : super(key: key);

  final String initials;
  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 64,
              foregroundImage: _image != null ? FileImage(_image!) : null,
              child: Text(
                widget.initials,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () async {
            final files = await imageHelper.pickImage();
            if (files.isNotEmpty) {
              final croppedFile = await imageHelper.crop(
                file: files.first,
                cropStyle: CropStyle.circle,
              );
              if (croppedFile != null) {
                setState(() => _image = File(croppedFile.path));
              }
            }
          },
          child: const Text('Select Photo'),
        ),
      ],
    );
  }
}

class MultipleImages extends StatefulWidget {
  const MultipleImages({Key? key}) : super(key: key);

  @override
  State<MultipleImages> createState() => _MultipleImagesState();
}

class _MultipleImagesState extends State<MultipleImages> {
  List<File> _images = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: _images
              .map(
                (e) => Image.file(
                  e,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () async {
            final files = await imageHelper.pickImage(multiple: true);
            setState(() => _images = files.map((e) => File(e.path)).toList());
          },
          child: const Text('Select Multiple Photos'),
        ),
      ],
    );
  }
}
