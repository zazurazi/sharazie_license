import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart'; // To open the generated PDF
import 'pdf_generator.dart'; // Replace this with your PDF generation logic

class CreateCertificatePage extends StatefulWidget {
  const CreateCertificatePage({super.key});

  @override
  _CreateCertificatePageState createState() => _CreateCertificatePageState();
}

class _CreateCertificatePageState extends State<CreateCertificatePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _certificateNumberController = TextEditingController();
  final _referenceNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _courseDateController = TextEditingController();

  Future<void> _saveCertificate() async {
    if (_formKey.currentState!.validate()) {
      final certificateData = {
        'certificateNumber': _certificateNumberController.text,
        'referenceNumber': _referenceNumberController.text,
        'name': _nameController.text,
        'idNumber': _idNumberController.text,
        'courseDate': _courseDateController.text,
        'academyName': "UNITED ACADEMY",
        'academyEntity': "UNITED ACADEMY PLT",
        'recognizedBy': "KEMENTERIAN KESIHATAN MALAYSIA",
        'courseName': "KURSUS LATIHAN PENGENDALI MAKANAN",
        'location': "UA TRAINING CENTRE, PETALING JAYA SELANGOR",
        'instructorName': "SITI MUNIRAH BINTI YAACOB",
        'instructorCertificateNumber': "B/0029/13",
      };

      try {
        // Save to Firestore
        await FirebaseFirestore.instance.collection('certificates').add(certificateData);

        // Generate PDF and save it locally
        final directory = await getApplicationDocumentsDirectory();
        final pdfPath = "${directory.path}/certificate_${certificateData['certificateNumber']}.pdf";
        await generateCertificatePdf(
          certificateNumber: certificateData['certificateNumber']!,
          referenceNumber: certificateData['referenceNumber']!,
          name: certificateData['name']!,
          idNumber: certificateData['idNumber']!,
          courseDate: certificateData['courseDate']!,
          academyName: certificateData['academyName']!,
          academyEntity: certificateData['academyEntity']!,
          recognizedBy: certificateData['recognizedBy']!,
          courseName: certificateData['courseName']!,
          location: certificateData['location']!,
          instructorName: certificateData['instructorName']!,
          instructorCertificateNumber: certificateData['instructorCertificateNumber']!,
        );

        // Open the generated PDF file
        await OpenFile.open(pdfPath);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Certificate saved and PDF generated successfully!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving certificate: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the entire background color to white
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add the image here
              Center(
                child: Image.asset(
                  'lib/assets/Create License logo.jpeg', // Replace with your image path
                  height: 250, // Adjust height
                  width: 250,  // Adjust width
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10), // Add spacing between the image and form

              // Certificate Number field
              TextFormField(
                controller: _certificateNumberController,
                decoration: InputDecoration(
                  labelText: 'Certificate Number (e.g., A/B/201-26/05/2024)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),

              // Reference Number field
              TextFormField(
                controller: _referenceNumberController,
                decoration: InputDecoration(
                  labelText: 'Reference Number (e.g., LPM 0025089)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),

              // Participant Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),

              // Participant ID Number field
              TextFormField(
                controller: _idNumberController,
                decoration: InputDecoration(
                  labelText: 'ID Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),

              // Course Date field
              TextFormField(
                controller: _courseDateController,
                decoration: InputDecoration(
                  labelText: 'Date (e.g., 7 JANUARI 2025)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 30),

              // Save Certificate Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Set button color to blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  onPressed: _saveCertificate,
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontFamily: 'Pacifico', // Set Pacifico font
                      fontSize: 20, // Adjust font size
                      color: Colors.black, // Black text color for contrast
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black, // Set background color to black
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), // Rounded corners
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white), // White icon
                onPressed: () {
                  Navigator.pop(context); // Navigate back to Home
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white), // White icon
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.credit_card_outlined, color: Colors.white), // White icon
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to Credit Card
                  // Add navigation logic here
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white), // White icon
                onPressed: () {
                  // Handle Sign Out
                  // Add sign-out logic here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
