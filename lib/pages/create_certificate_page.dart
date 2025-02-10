import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:sharazie_license/pages/home_screen.dart';
import 'pdf_generator.dart';
import 'home_page.dart';
import 'profile_page.dart';

class CreateCertificatePage extends StatefulWidget {
  const CreateCertificatePage({super.key});

  @override
  _CreateCertificatePageState createState() => _CreateCertificatePageState();
}

class _CreateCertificatePageState extends State<CreateCertificatePage> {
  final _formKey = GlobalKey<FormState>();
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
      };

      try {
        await FirebaseFirestore.instance.collection('certificates').add(certificateData);

        final directory = await getApplicationDocumentsDirectory();
        final pdfPath = "${directory.path}/certificate_${certificateData['certificateNumber']}.pdf";
        await generateCertificatePdf(
          certificateNumber: certificateData['certificateNumber']!,
          referenceNumber: certificateData['referenceNumber']!,
          name: certificateData['name']!,
          idNumber: certificateData['idNumber']!,
          courseDate: certificateData['courseDate']!,
          academyName: '',
          academyEntity: '',
          recognizedBy: '',
          courseName: '',
          location: '',
          instructorName: '',
          instructorCertificateNumber: '',
        );

        await OpenFile.open(pdfPath);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Certificate saved and PDF generated successfully!',
              style: TextStyle(fontFamily: 'SFProRounded'),
            ),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error saving certificate: $e',
              style: const TextStyle(fontFamily: 'SFProRounded'),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              // Title with Logo
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,  // Ensures minimal space usage
                      children: [
                        Image.asset(
                          'lib/assets/logo.jpeg',
                          height: 45, // Adjust size as needed
                        ),
                        const SizedBox(width: 0), // Adds spacing between logo and text
                        const Text(
                          'Create License',
                          style: TextStyle(
                            fontFamily: 'SFProRounded',
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60), // Spacing between title and new text
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Fill in the data:',
                        style: TextStyle(
                          fontFamily: 'SFProRounded',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // Adjust the border radius for rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: _buildTextField(_certificateNumberController, 'Certificate Number'),
              ),
              const SizedBox(height: 23),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: _buildTextField(_referenceNumberController, 'Reference Number'),
              ),
              const SizedBox(height: 23),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: _buildTextField(_nameController, 'Name'),
              ),
              const SizedBox(height: 23),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: _buildTextField(_idNumberController, 'ID Number'),
              ),
              const SizedBox(height: 23),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: _buildTextField(_courseDateController, 'Date'),
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    elevation: 5, // Adding shadow
                  ),
                  onPressed: _saveCertificate,
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontFamily: 'SFProRounded',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontFamily: 'SFProRounded'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.black, // Black border color
            width: 2.0, // Border width
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.black, // Black border color when focused
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.black, // Black border color when enabled
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      style: const TextStyle(fontFamily: 'SFProRounded'),
      validator: (value) => value!.isEmpty ? 'Required' : null,
    );
  }


  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(Icons.home, 'Home', () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
            _buildNavBarItem(Icons.person, 'Profile', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            }),
            _buildNavBarItem(Icons.credit_card_outlined, 'Payment', () {
              Navigator.pop(context);
            }),
            _buildNavBarItem(Icons.logout, 'Logout', () {
              // Handle logout logic
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onTap,
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SFProRounded',
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
