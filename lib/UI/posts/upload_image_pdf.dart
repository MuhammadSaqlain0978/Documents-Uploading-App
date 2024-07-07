import 'dart:io';
import 'package:docup_app/Widgets/round_button.dart';

import 'package:docup_app/UI/uploaded_list/Retrive_Pdf_Image.dart';
import 'package:docup_app/UI/uploaded_list/Retrive_images_only.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadImageAndPdfScreen extends StatefulWidget {
  const UploadImageAndPdfScreen({super.key});

  @override
  State<UploadImageAndPdfScreen> createState() =>
      _UploadImageAndPdfScreenState();
}

class _UploadImageAndPdfScreenState extends State<UploadImageAndPdfScreen> {
  File? _image;
  final Imgpicker = ImagePicker();

  File? _pdf;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getImageGallery() async {
    final pickedFile = await Imgpicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Future pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdf = File(result.files.single.path!);
      });
    } else {
      print('No file selected');
    }
  }

  Future uploadImageAndPdfToFirestore() async {
    if (_image == null || _pdf == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both an image and a PDF')),
      );
      return;
    }

    String folderName = DateTime.now().millisecondsSinceEpoch.toString();

    // Upload image to Firebase Storage
    firebase_storage.Reference imageRef = storage.ref(
        'Image and Pdf/$folderName/${DateTime.now().millisecondsSinceEpoch}.jpg');
    firebase_storage.UploadTask imageUploadTask = imageRef.putFile(_image!);
    await imageUploadTask;
    String imageDownloadUrl = await imageRef.getDownloadURL();

    // Upload PDF to Firebase Storage
    firebase_storage.Reference pdfRef = storage.ref(
        'Image and Pdf/$folderName/${DateTime.now().millisecondsSinceEpoch}.pdf');
    firebase_storage.UploadTask pdfUploadTask = pdfRef.putFile(_pdf!);
    await pdfUploadTask;
    String pdfDownloadUrl = await pdfRef.getDownloadURL();

    // Save the download URLs to Firestore
    await firestore.collection('Image with Pdf').add({
      'image_url': imageDownloadUrl,
      'pdf_url': pdfDownloadUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image and PDF Uploaded Successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image and PDF'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: getImageGallery,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Colors.grey[400]!,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _image!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Tap to select image',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: pickPdf,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Colors.grey[400]!,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _pdf != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.picture_as_pdf,
                                  size: 50, color: Colors.red),
                              SizedBox(height: 10),
                              Text('PDF Selected',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.picture_as_pdf,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Tap to select PDF',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              RoundButton(
                title: 'Upload',
                onTap: uploadImageAndPdfToFirestore,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.remove_red_eye),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayImageAndPdfScreen()));
          }),
    );
  }
}
