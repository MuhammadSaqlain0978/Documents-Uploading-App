import 'package:docup_app/UI/upload_image.dart';
import 'package:docup_app/UI/uploaded_list/Retrive_Pdf_only.dart';
import 'package:docup_app/UI/uploaded_list/Retrive_text.dart';
import 'package:flutter/material.dart';
import 'package:docup_app/UI/uploaded_list/Retrive_images_only.dart';
import 'package:docup_app/UI/uploaded_list/Retrive_image_w_text.dart';
import 'package:docup_app/UI/uploaded_list/Retrive_Pdf_Text.dart';
import 'package:docup_app/UI/uploaded_list/Retrive_Pdf_Image.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Uploaded Data Categories'),
          backgroundColor: Colors.cyan,
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            CategoryCard(
              title: 'Text Only',
              icon: Icons.text_fields,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DisplayTextOnly()));
                // Navigate to the screen showing 'Text Only' uploads
              },
            ),
            CategoryCard(
              title: 'Image Only',
              icon: Icons.image,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DisplayImagesOnlyScreen()));
              },
            ),
            CategoryCard(
              title: 'Image with Text',
              icon: Icons.image_aspect_ratio,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DisplayImagesWithTextScreen()));

                // Navigate to the screen showing 'Image with Text' uploads
              },
            ),
            CategoryCard(
              title: 'PDF Only',
              icon: Icons.picture_as_pdf,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DisplayPdfOnlyScreen()));

                // PdfOnlyScreen()
                // Navigate to the screen showing 'PDF Only' uploads
              },
            ),
            CategoryCard(
              title: 'Image and PDF',
              icon: Icons.attach_file,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DisplayImageAndPdfScreen()));

                // Navigate to the screen showing 'Image and PDF' uploads
              },
            ),
            CategoryCard(
              title: 'PDF with Text',
              icon: Icons.text_snippet_outlined,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DisplayPdfWithTextScreen()));

                // PdfOnlyScreen()
                // Navigate to the screen showing 'PDF Only' uploads
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  CategoryCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
