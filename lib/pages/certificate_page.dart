import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pdf_generator.dart';

class GenerateCertificatePage extends StatefulWidget {
  @override
  _GenerateCertificatePageState createState() => _GenerateCertificatePageState();
}

class _GenerateCertificatePageState extends State<GenerateCertificatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _certificateNumberController = TextEditingController();
  final TextEditingController _referenceNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _courseDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Certificate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _certificateNumberController,
                decoration: InputDecoration(labelText: 'Certificate Number'),
                validator: (value) => value!.isEmpty ? 'Please enter a certificate number' : null,
              ),
              TextFormField(
                controller: _referenceNumberController,
                decoration: InputDecoration(labelText: 'Reference Number'),
                validator: (value) => value!.isEmpty ? 'Please enter a reference number' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Participant Name'),
                validator: (value) => value!.isEmpty ? 'Please enter the participant name' : null,
              ),
              TextFormField(
                controller: _idNumberController,
                decoration: InputDecoration(labelText: 'ID Number'),
                validator: (value) => value!.isEmpty ? 'Please enter the ID number' : null,
              ),
              TextFormField(
                controller: _courseDateController,
                decoration: InputDecoration(labelText: 'Course Date (e.g., 7 JANUARI 2025)'),
                validator: (value) => value!.isEmpty ? 'Please enter the course date' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await FirebaseFirestore.instance.collection('certificates').add({
                      'certificateNumber': _certificateNumberController.text,
                      'referenceNumber': _referenceNumberController.text,
                      'name': _nameController.text,
                      'idNumber': _idNumberController.text,
                      'courseDate': _courseDateController.text,
                    });

                    await generateCertificatePdf(
                      certificateNumber: _certificateNumberController.text,
                      referenceNumber: _referenceNumberController.text,
                      name: _nameController.text,
                      idNumber: _idNumberController.text,
                      courseDate: _courseDateController.text,
                      academyName: "UNITED ACADEMY",
                      academyEntity: "UNITED ACADEMY PLT",
                      recognizedBy: "KEMENTERIAN KESIHATAN MALAYSIA",
                      courseName: "KURSUS LATIHAN PENGENDALI MAKANAN",
                      location: "UA TRAINING CENTRE, PETALING JAYA SELANGOR",
                      instructorName: "SITI MUNIRAH BINTI YAACOB",
                      instructorCertificateNumber: "B/0029/13",
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Certificate generated!')),
                    );

                    Navigator.pop(context);
                  }
                },
                child: Text('Generate Certificate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
