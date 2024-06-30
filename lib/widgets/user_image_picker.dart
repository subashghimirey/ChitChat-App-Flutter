import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? userImage;

  void pickImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if (image == null) {
      return;
    }

    setState(() {
      userImage = File(image.path);
    });

    widget.onPickImage(userImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 50,
          foregroundImage: userImage != null ? FileImage(userImage!) : null,
        ),
        TextButton.icon(
            onPressed: pickImage,
            icon: const Icon(Icons.image),
            label: const Text("Add image"))
      ],
    );
  }
}
