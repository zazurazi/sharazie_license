import 'dart:io';
import 'dart:typed_data';
import 'dart:convert'; // ✅ For Base64 encoding
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _image;
  File? selectedImage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController icController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfileData(); // ✅ Load saved profile data (including photo)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: pacificoStyle(24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                      radius: 80, backgroundImage: MemoryImage(_image!))
                      : const CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 10,
                      child: IconButton(
                          onPressed: () {
                            showImagePickerOption(context);
                          },
                          icon: const Icon(Icons.add_a_photo,
                              size: 30, color: Colors.black)))
                ],
              ),
              const SizedBox(height: 20),
              buildTextField("Full Name", nameController),
              buildTextField("IC Number", icController),
              buildTextField("Email", emailController),
              buildTextField("Phone Number", phoneController),
              buildTextField("Gender", genderController),
              buildTextField("Date of Birth", dobController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // ✅ Set blue color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // ✅ Rounded button
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  "Save Profile",
                  style: pacificoStyle(18).copyWith(color: Colors.black), // ✅ Pacifico font + White color
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.grey[200],
        context: context,
        builder: (builder) {
          return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: _pickImageFromGallery,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.image, size: 80),
                          Text("Gallery")
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: _pickImageFromCamera,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.camera_alt_outlined, size: 80),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  Future _pickImageFromGallery() async {
    final returnImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    saveImage(_image!); // ✅ Save image to SharedPreferences
    Navigator.of(context).pop();
  }

  Future _pickImageFromCamera() async {
    final returnImage =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    saveImage(_image!); // ✅ Save image to SharedPreferences
    Navigator.of(context).pop();
  }

  Future<void> saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('ic', icController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('gender', genderController.text);
    await prefs.setString('dob', dobController.text);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Saved Successfully!")));
  }

  Future<void> saveImage(Uint8List imageBytes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    await prefs.setString('profileImage', base64Image);
  }

  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? "";
      icController.text = prefs.getString('ic') ?? "";
      emailController.text = prefs.getString('email') ?? "";
      phoneController.text = prefs.getString('phone') ?? "";
      genderController.text = prefs.getString('gender') ?? "";
      dobController.text = prefs.getString('dob') ?? "";

      String? base64Image = prefs.getString('profileImage');
      if (base64Image != null) {
        _image = base64Decode(base64Image);
      }
    });
  }

  TextStyle pacificoStyle(double size) {
    return TextStyle(
      fontFamily: 'Pacifico',
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }
}
