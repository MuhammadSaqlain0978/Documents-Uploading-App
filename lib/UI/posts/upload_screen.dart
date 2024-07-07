import 'package:docup_app/UI/posts/upload_image_pdf.dart';
import 'package:docup_app/UI/posts/upload_pdf_only.dart';
import 'package:docup_app/UI/posts/upload_pdf_text.dart';
import 'package:docup_app/Widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:docup_app/UI/posts/upload_text.dart';
import 'package:docup_app/UI/upload_image.dart';
import 'package:docup_app/UI/posts/upload_image_w_text.dart';
import 'package:docup_app/UI/uploaded_list/catogeries_screen.dart';

class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Upload Activity',
            style: TextStyle(fontSize: 24),
          ),
          backgroundColor: Colors.cyan,
        ),
        body: ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.text_fields, color: Colors.teal),
                title: Text(
                  'Upload Text Only',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadTextScreen()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.image, color: Colors.teal),
                title: Text(
                  'Upload Image Only',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadImageScreen()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.image_aspect_ratio, color: Colors.teal),
                title: Text(
                  'Upload Image with Text',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadImageWithTextScreen()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.teal),
                title: Text(
                  'Upload Text with PDF',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadPdfWithTextScreen()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading:
                    Icon(Icons.picture_as_pdf_outlined, color: Colors.teal),
                title: Text(
                  'Upload PDF Only',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadPdfScreen()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.image_search, color: Colors.teal),
                title: Text(
                  'Upload Image with PDF',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadImageAndPdfScreen()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 220,
            ),
            RoundButton(
                title: 'View Uploaded Documents',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoriesScreen()),
                  );
                })
          ],
        ),
      ),
    );
  }
}
