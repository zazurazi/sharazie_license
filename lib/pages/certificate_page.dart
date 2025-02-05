import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharazie_license/pages/pdf_generator.dart';
import 'create_certificate_page.dart'; // Import CreateCertificatePage

class CertificatePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateCertificate(BuildContext context, Map<String, dynamic> data) async {
    try {
      await generateCertificatePdf(
        certificateNumber: data['certificateNumber'] ?? '',
        referenceNumber: data['referenceNumber'] ?? '',
        name: data['name'] ?? '',
        idNumber: data['idNumber'] ?? '',
        courseDate: data['courseDate'] ?? '',
        academyName: data['academyName'] ?? '',
        academyEntity: data['academyEntity'] ?? '',
        recognizedBy: data['recognizedBy'] ?? '',
        courseName: data['courseName'] ?? '',
        location: data['location'] ?? '',
        instructorName: data['instructorName'] ?? '',
        instructorCertificateNumber: data['instructorCertificateNumber'] ?? '',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Certificate successfully generated for ${data['name']}!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating certificate: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color of the whole Scaffold
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'lib/assets/logo.jpeg', // Replace with the correct image path
              height: 40, // Adjust the height of the image
            ),
            const SizedBox(width: 2), // Add space between the image and the text
            const Text(
              "Sharazie License",
              style: TextStyle(
                fontFamily: 'Pacifico', // Use Pacifico font
                fontSize: 24, // Adjust font size if needed
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white, // Make AppBar background white
        elevation: 0, // Remove shadow from AppBar
      ),
      body: Container(
        color: Colors.white, // Ensure the body background is white
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('certificates').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error fetching data: ${snapshot.error}'));
            }

            final documents = snapshot.data?.docs ?? [];

            if (documents.isEmpty) {
              return const Center(child: Text('No certificates available.'));
            }

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final data = documents[index].data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(data['name'] ?? ''),
                    subtitle: Text(data['courseName'] ?? ''),
                    trailing: const Icon(Icons.download),
                    onTap: () {
                      generateCertificate(context, data);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCertificatePage()),
          );
        },
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder( // Make the button rounded
          borderRadius: BorderRadius.circular(23.0), // Adjust the radius for more/less roundness
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
