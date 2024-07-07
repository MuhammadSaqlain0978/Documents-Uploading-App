import 'dart:io';

import 'package:docup_app/Widgets/round_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Future<void> uploadImageToFirestore() async {
    if (_image == null) return;

    // Upload image to Firebase Storage
    firebase_storage.Reference ref =
        storage.ref('images only/${DateTime.now().millisecondsSinceEpoch}.jpg');
    firebase_storage.UploadTask uploadTask = ref.putFile(_image!);

    await uploadTask;

    // Get download URL
    String downloadUrl = await ref.getDownloadURL();

    // Save the download URL to Firestore
    await firestore.collection('Photos Only').add({'url': downloadUrl});

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image Uploaded and Path Saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Upload Image',
          ),
          backgroundColor: Colors.cyan,
        ),
        body: InkWell(
          onTap: () {
            getImageGallery();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[400]!,
                    ),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Icon(
                          Icons.image_search,
                          size: 50,
                        ),
                ),
              ),
              SizedBox(height: 40),
              RoundButton(
                title: 'Upload',
                onTap: uploadImageToFirestore,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
